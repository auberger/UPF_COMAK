/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package org.opensim.modeling;

/**
 *  Derive from this class to implement your own way of reporting logged<br>
 *  messages.
 */
public class LogSink {
  private transient long swigCPtr;
  private transient boolean swigCMemOwn;

  protected LogSink(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(LogSink obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  protected void swigSetCMemOwn(boolean own) {
    swigCMemOwn = own;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        opensimCommonJNI.delete_LogSink(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  protected void swigDirectorDisconnect() {
    swigSetCMemOwn(false);
    delete();
  }

  public void swigReleaseOwnership() {
    swigSetCMemOwn(false);
    opensimCommonJNI.LogSink_change_ownership(this, swigCPtr, false);
  }

  public void swigTakeOwnership() {
    swigSetCMemOwn(true);
    opensimCommonJNI.LogSink_change_ownership(this, swigCPtr, true);
  }

  public void markAdopted() {
      if (swigCPtr != 0) {
          if (swigCMemOwn) swigCMemOwn = false;
      }
  }

  /**
   *  This function is invoked whenever a message is logged at the desired<br>
   *  Log::Level.
   */
  protected void sinkImpl(String msg) {
    opensimCommonJNI.LogSink_sinkImpl(swigCPtr, this, msg);
  }

  protected void flushImpl() {
    if (getClass() == LogSink.class) opensimCommonJNI.LogSink_flushImpl(swigCPtr, this); else opensimCommonJNI.LogSink_flushImplSwigExplicitLogSink(swigCPtr, this);
  }

  public LogSink() {
    this(opensimCommonJNI.new_LogSink(), true);
    opensimCommonJNI.LogSink_director_connect(this, swigCPtr, true, true);
  }

}
