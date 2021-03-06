
using OpenGL;
using Uno.Runtime.Implementation;
using Uno.Compiler.ExportTargetInterop;

namespace Uno.Graphics
{
    [extern(DOTNET) DotNetType]
    public extern(!MOBILE) sealed class GraphicsController : GraphicsContext
    {
        internal Recti _viewport;
        internal Recti _scissor;
        internal RenderTarget _backbuffer;
        internal RenderTarget _renderTarget;

        bool _scissorEnabled = false;

        internal GraphicsController() : base(GraphicsControllerImpl.GetInstance())
        {
            ClearColor = float4(0,0,0,1);
            ClearDepth = 1;
            _renderTarget = _backbuffer = new RenderTarget();
            UpdateBackbuffer();
        }

        internal void UpdateBackbuffer()
        {
            if defined(OPENGL)
                _backbuffer.GLFramebufferHandle = GraphicsControllerImpl.GetBackbufferGLHandle(_handle);

            _backbuffer.Size = GraphicsControllerImpl.GetBackbufferSize(_handle);
            _backbuffer.HasDepth = true;
        }

        public RenderTarget Backbuffer
        {
            get { return _backbuffer; }
        }

        public RenderTarget RenderTarget
        {
            get
            {
                return _renderTarget;
            }
        }

        public Recti Scissor
        {
            get { return _scissor;}
            set
            {
                if defined(OPENGL)
                {
                    if (!_scissorEnabled) // because i don't know where to turn this on
                    {
                        GL.Enable(GLEnableCap.ScissorTest);
                        _scissorEnabled = true;
                    }

                    _scissor = value;
                    if (_renderTarget == _backbuffer)
                    {
                        var offset = GraphicsControllerImpl.GetBackbufferOffset(_handle);
                        var realFbHeight = GraphicsControllerImpl.GetRealBackbufferHeight(_handle);
                        var offsetScissor = new Recti(_scissor.Position + offset, _scissor.Size);
                        var currentScissor = GraphicsControllerImpl.GetBackbufferScissor(_handle);
                        var clippedScissor = new Recti(
                            Uno.Math.Max(offsetScissor.Left, currentScissor.Left),
                            Uno.Math.Max(offsetScissor.Top, currentScissor.Top),
                            Uno.Math.Min(offsetScissor.Right, currentScissor.Right),
                            Uno.Math.Min(offsetScissor.Bottom, currentScissor.Bottom)); // TODO: Some kind of Recti.Intersect[ion] would be better here

                        GL.Scissor(clippedScissor.Left,
                            realFbHeight - clippedScissor.Bottom,
                            Math.Max(0, clippedScissor.Size.X),
                            Math.Max(0, clippedScissor.Size.Y));

                    }
                    else
                    {
                        GL.Scissor(_scissor.Left, _renderTarget.Size.Y - _scissor.Bottom, Math.Max(0, _scissor.Size.X), Math.Max(0, _scissor.Size.Y));
                    }
                }
                else
                {
                    build_error;
                }
            }
        }

        public Recti Viewport
        {
            get { return _viewport; }
            set
            {
                if defined(OPENGL)
                {
                    _viewport = value;
                    if (_renderTarget == _backbuffer)
                    {
                        var offset = GraphicsControllerImpl.GetBackbufferOffset(_handle);
                        var realFbHeight = GraphicsControllerImpl.GetRealBackbufferHeight(_handle);
                        var offsetViewport = new Recti(_viewport.Position + offset, _viewport.Size);

                        GL.Viewport(offsetViewport.Left,
                            realFbHeight - offsetViewport.Bottom,
                            Math.Max(0, offsetViewport.Size.X),
                            Math.Max(0, offsetViewport.Size.Y));

                    }
                    else
                    {
                        GL.Viewport(_viewport.Left, _renderTarget.Size.Y - _viewport.Bottom, Math.Max(0, _viewport.Size.X), Math.Max(0, _viewport.Size.Y));
                    }
                }
                else
                {
                    build_error;
                }
            }
        }

        public void SetRenderTarget(RenderTarget renderTarget)
        {
            if (renderTarget == null)
                throw new ArgumentNullException(nameof(renderTarget));

            var full = new Recti(int2(0), renderTarget.Size);
            SetRenderTarget(renderTarget, full, full);
        }

        public void SetRenderTarget(RenderTarget renderTarget, Recti viewport, Recti scissor)
        {
            if (renderTarget == null)
                throw new ArgumentNullException(nameof(renderTarget));

            _renderTarget = renderTarget;

            if defined(OPENGL)
                GL.BindFramebuffer(GLFramebufferTarget.Framebuffer, _renderTarget.GLFramebufferHandle);

            Viewport = viewport;
            Scissor = scissor;
        }

        public float4 ClearColor
        {
            get;
            set;
        }

        public float ClearDepth
        {
            get;
            protected set;
        }

        public void Clear(float4 color, float depth)
        {
            if defined(OPENGL)
            {
                GL.ClearDepth(depth);
                GL.ClearColor(color.X, color.Y, color.Z, color.W);
                GL.Clear(GLClearBufferMask.ColorBufferBit | GLClearBufferMask.DepthBufferBit | GLClearBufferMask.StencilBufferBit);
            }
        }
    }
}
