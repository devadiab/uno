using Uno.Compiler.ExportTargetInterop;
using Uno.Runtime.Implementation;

namespace Uno.Platform
{
    [Obsolete("Deprecated on mobile. Please interact with UI through fuselibs")]
    public extern(MOBILE) sealed class Window : OSFrame
    {
        internal Window() : base()
        {
            Uno.Platform.Displays.MainDisplay.Tick += OnTick;
            Uno.Platform.CoreApp.EnteringInteractive += OnGotFocus;
            Uno.Platform.CoreApp.ExitedInteractive += OnLostFocus;
        }

        [Obsolete("Deprecated on mobile. This will perform an unsafe quit which is bad practise on Android and will disqualify the app from the iOS app store")]
        public void Close()
        {
            Uno.Runtime.Implementation.Internal.Unsafe.Quit();
        }

        [Obsolete("Deprecated on mobile: Window titles cannot be controlled at runtime across mobile devices")]
        public string Title
        {
            get { return "<INVALID>"; }
            set { }
        }

        [Obsolete("Invalid on mobile: Will throw exception at runtime")]
        public PointerCursor PointerCursor
        {
            get
            {
                throw new Uno.Exception("PointerCursor is invalid on mobile");
                return PointerCursor.None;
            }
            set
            {
                throw new Uno.Exception("PointerCursor is invalid on mobile");
            }
        }

        [Obsolete("Invalid on mobile: Please interact with UI through fuselibs")]
        public int2 ClientSize
        {
            get
            {
                throw new Exception("Window ClientSize not available on mobile");
                return int2(0,0);
            }
            set { }
        }

        [Obsolete("Deprecated on mobile: Mobile apps don't ubiquitously allow this kind of control")]
        public bool Fullscreen
        {
            get { return true; }
            set { }
        }

        [Obsolete("Deprecated: Please use Uno.Platform.EventSources.TextSource.IsTextInputActive")]
        public bool IsTextInputActive
        {
            get { return Uno.Platform.EventSources.TextSource.IsTextInputActive; }
        }
                [Obsolete("Deprecated: Please use Uno.Platform.EventSources.TextSource.TextInput")]
        public event EventHandler<TextInputEventArgs> TextInput;
        [Obsolete("Deprecated: Invalid on desktop")]
        public event EventHandler KeyboardResized;

        [Obsolete("Deprecated: Please use Uno.Platform.HardwareKeys.KeyDown")]
        public event EventHandler<KeyEventArgs> KeyPressed
        {
            add { Uno.Platform.EventSources.HardwareKeys.KeyDown += value; }
            remove { Uno.Platform.EventSources.HardwareKeys.KeyDown -= value; }
        }

        [Obsolete("Deprecated: Please use Uno.Platform.HardwareKeys.KeyUp")]
        public event EventHandler<KeyEventArgs> KeyReleased
        {
            add { Uno.Platform.EventSources.HardwareKeys.KeyUp += value; }
            remove { Uno.Platform.EventSources.HardwareKeys.KeyUp -= value; }
        }

        [Obsolete("Deprecated: Please use Uno.Platform.Displays.MainDisplay.Tick")]
        public event EventHandler Updating;
        void OnTick(object sender, Uno.Platform.TimerEventArgs args)
        {
            var handler = Updating;
            if (handler!=null)
                handler(sender, EventArgs.Empty);
        }

        [Obsolete("Deprecated: Please use Uno.Platform.CoreApp.EnteringInteractive")]
        public event EventHandler GotFocus;
        void OnGotFocus(Uno.Platform.ApplicationState newState)
        {
            var handler = GotFocus;
            if (handler!=null)
                handler(null, EventArgs.Empty);
        }
        [Obsolete("Deprecated: Please use Uno.Platform.CoreApp.ExitedInteractive")]
        public event EventHandler LostFocus;
        void OnLostFocus(Uno.Platform.ApplicationState newState)
        {
            var handler = LostFocus;
            if (handler!=null)
                handler(null, EventArgs.Empty);
        }
    }


    [extern(DOTNET) DotNetType]
    public extern(!MOBILE) sealed class Window : OSFrame
    {
        internal Window() : base()
        {
            Uno.Platform.Displays.MainDisplay.Tick += OnTick;
            Uno.Platform.CoreApp.EnteringInteractive += OnGotFocus;
            Uno.Platform.CoreApp.ExitedInteractive += OnLostFocus;
            _handle = PlatformWindowImpl.GetInstance();
        }

        public void Close()
        {
            PlatformWindowImpl.Close(_handle);
        }

        public string Title
        {
            get { return PlatformWindowImpl.GetTitle(_handle); }
            set { PlatformWindowImpl.SetTitle(_handle, value); }
        }

        public PointerCursor PointerCursor
        {
            get { return PlatformWindowImpl.GetPointerCursor(_handle); }
            set { PlatformWindowImpl.SetPointerCursor(_handle, value); }
        }

        public int2 ClientSize
        {
            get { return PlatformWindowImpl.GetClientSize(_handle); }
            set { PlatformWindowImpl.SetClientSize(_handle, value); }
        }

        public bool Fullscreen
        {
            get { return PlatformWindowImpl.GetFullscreen(_handle); }
            set { PlatformWindowImpl.SetFullscreen(_handle, value); }
        }

        [Obsolete("Deprecated: Please use Uno.Platform.EventSources.TextSource.IsTextInputActive")]
        public bool IsTextInputActive
        {
            get { return PlatformWindowImpl.IsTextInputActive(_handle); }
        }
        [Obsolete("Deprecated: Please use Uno.Platform.EventSources.TextSource.TextInput")]
        public event EventHandler<TextInputEventArgs> TextInput;
        [Obsolete("Deprecated: Invalid on desktop")]
        public event EventHandler KeyboardResized;

        [Obsolete("Deprecated: Please use Uno.Platform.HardwareKeys.KeyDown")]
        public event EventHandler<KeyEventArgs> KeyPressed
        {
            add { Uno.Platform.EventSources.HardwareKeys.KeyDown += value; }
            remove { Uno.Platform.EventSources.HardwareKeys.KeyDown -= value; }
        }

        [Obsolete("Deprecated: Please use Uno.Platform.HardwareKeys.KeyUp")]
        public event EventHandler<KeyEventArgs> KeyReleased
        {
            add { Uno.Platform.EventSources.HardwareKeys.KeyUp += value; }
            remove { Uno.Platform.EventSources.HardwareKeys.KeyUp -= value; }
        }

        [Obsolete("Deprecated: Please use Uno.Platform.Displays.MainDisplay.Tick")]
        public event EventHandler Updating;
        void OnTick(object sender, Uno.Platform.TimerEventArgs args)
        {
            var handler = Updating;
            if (handler!=null)
                handler(sender, EventArgs.Empty);
        }

        [Obsolete("Deprecated: Please use Uno.Platform.CoreApp.EnteringInteractive")]
        public event EventHandler GotFocus;
        void OnGotFocus(Uno.Platform.ApplicationState newState)
        {
            var handler = GotFocus;
            if (handler!=null)
                handler(null, EventArgs.Empty);
        }
        [Obsolete("Deprecated: Please use Uno.Platform.CoreApp.ExitedInteractive")]
        public event EventHandler LostFocus;
        void OnLostFocus(Uno.Platform.ApplicationState newState)
        {
            var handler = LostFocus;
            if (handler!=null)
                handler(null, EventArgs.Empty);
        }
    }
}
