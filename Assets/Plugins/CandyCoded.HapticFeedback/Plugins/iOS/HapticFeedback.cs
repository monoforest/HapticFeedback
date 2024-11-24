// Copyright (c) Scott Doxey. All Rights Reserved. Licensed under the MIT License. See LICENSE in the project root for license information.

using System.Runtime.InteropServices;

namespace CandyCoded.HapticFeedback.iOS
{

    public static class HapticFeedback
    {

        // [DllImport("__Internal")]
        // public static extern void PerformHapticFeedback(string style = "medium");

        [DllImport("__Internal")]
        private static extern void PerformHapticFeedback(string style = "light");
    
        [DllImport("__Internal")]
        private static extern void CleanupHapticFeedback();
    
        public static void Generate(string style)
        {
    #if UNITY_IOS && !UNITY_EDITOR
            PerformHapticFeedback(style);
    #endif
        }
    
        public static void Dispose()
        {
    #if UNITY_IOS && !UNITY_EDITOR
            CleanupHapticFeedback();
    #endif
        }

    }

}
