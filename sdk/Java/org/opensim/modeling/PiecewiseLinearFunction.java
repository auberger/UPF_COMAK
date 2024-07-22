/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package org.opensim.modeling;

/**
 * A class implementing a linear function.<br>
 * <br>
 * This class inherits from Function and so can be used as input to<br>
 * any class requiring a Function as input.<br>
 * <br>
 * @author Peter Loan<br>
 * @version 1.0
 */
public class PiecewiseLinearFunction extends Function {
  private transient long swigCPtr;

  public PiecewiseLinearFunction(long cPtr, boolean cMemoryOwn) {
    super(opensimCommonJNI.PiecewiseLinearFunction_SWIGUpcast(cPtr), cMemoryOwn);
    swigCPtr = cPtr;
  }

  public static long getCPtr(PiecewiseLinearFunction obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        opensimCommonJNI.delete_PiecewiseLinearFunction(swigCPtr);
      }
      swigCPtr = 0;
    }
    super.delete();
  }

  public static PiecewiseLinearFunction safeDownCast(OpenSimObject obj) {
    long cPtr = opensimCommonJNI.PiecewiseLinearFunction_safeDownCast(OpenSimObject.getCPtr(obj), obj);
    return (cPtr == 0) ? null : new PiecewiseLinearFunction(cPtr, false);
  }

  public void assign(OpenSimObject aObject) {
    opensimCommonJNI.PiecewiseLinearFunction_assign(swigCPtr, this, OpenSimObject.getCPtr(aObject), aObject);
  }

  public static String getClassName() {
    return opensimCommonJNI.PiecewiseLinearFunction_getClassName();
  }

  public OpenSimObject clone() {
    long cPtr = opensimCommonJNI.PiecewiseLinearFunction_clone(swigCPtr, this);
    return (cPtr == 0) ? null : new PiecewiseLinearFunction(cPtr, true);
  }

  public String getConcreteClassName() {
    return opensimCommonJNI.PiecewiseLinearFunction_getConcreteClassName(swigCPtr, this);
  }

  public PiecewiseLinearFunction() {
    this(opensimCommonJNI.new_PiecewiseLinearFunction__SWIG_0(), true);
  }

  public PiecewiseLinearFunction(int aN, SWIGTYPE_p_double aTimes, SWIGTYPE_p_double aValues, String aName) {
    this(opensimCommonJNI.new_PiecewiseLinearFunction__SWIG_1(aN, SWIGTYPE_p_double.getCPtr(aTimes), SWIGTYPE_p_double.getCPtr(aValues), aName), true);
  }

  public PiecewiseLinearFunction(int aN, SWIGTYPE_p_double aTimes, SWIGTYPE_p_double aValues) {
    this(opensimCommonJNI.new_PiecewiseLinearFunction__SWIG_2(aN, SWIGTYPE_p_double.getCPtr(aTimes), SWIGTYPE_p_double.getCPtr(aValues)), true);
  }

  public PiecewiseLinearFunction(PiecewiseLinearFunction aFunction) {
    this(opensimCommonJNI.new_PiecewiseLinearFunction__SWIG_3(PiecewiseLinearFunction.getCPtr(aFunction), aFunction), true);
  }

  public void init(Function aFunction) {
    opensimCommonJNI.PiecewiseLinearFunction_init(swigCPtr, this, Function.getCPtr(aFunction), aFunction);
  }

  public int getSize() {
    return opensimCommonJNI.PiecewiseLinearFunction_getSize(swigCPtr, this);
  }

  public ArrayDouble getX() {
    return new ArrayDouble(opensimCommonJNI.PiecewiseLinearFunction_getX__SWIG_0(swigCPtr, this), false);
  }

  public ArrayDouble getY() {
    return new ArrayDouble(opensimCommonJNI.PiecewiseLinearFunction_getY__SWIG_0(swigCPtr, this), false);
  }

  public SWIGTYPE_p_double getXValues() {
    long cPtr = opensimCommonJNI.PiecewiseLinearFunction_getXValues(swigCPtr, this);
    return (cPtr == 0) ? null : new SWIGTYPE_p_double(cPtr, false);
  }

  public SWIGTYPE_p_double getYValues() {
    long cPtr = opensimCommonJNI.PiecewiseLinearFunction_getYValues(swigCPtr, this);
    return (cPtr == 0) ? null : new SWIGTYPE_p_double(cPtr, false);
  }

  public int getNumberOfPoints() {
    return opensimCommonJNI.PiecewiseLinearFunction_getNumberOfPoints(swigCPtr, this);
  }

  public double getX(int aIndex) {
    return opensimCommonJNI.PiecewiseLinearFunction_getX__SWIG_1(swigCPtr, this, aIndex);
  }

  public double getY(int aIndex) {
    return opensimCommonJNI.PiecewiseLinearFunction_getY__SWIG_1(swigCPtr, this, aIndex);
  }

  public double getZ(int aIndex) {
    return opensimCommonJNI.PiecewiseLinearFunction_getZ(swigCPtr, this, aIndex);
  }

  public void setX(int aIndex, double aValue) {
    opensimCommonJNI.PiecewiseLinearFunction_setX(swigCPtr, this, aIndex, aValue);
  }

  public void setY(int aIndex, double aValue) {
    opensimCommonJNI.PiecewiseLinearFunction_setY(swigCPtr, this, aIndex, aValue);
  }

  public boolean deletePoint(int aIndex) {
    return opensimCommonJNI.PiecewiseLinearFunction_deletePoint(swigCPtr, this, aIndex);
  }

  public boolean deletePoints(ArrayInt indices) {
    return opensimCommonJNI.PiecewiseLinearFunction_deletePoints(swigCPtr, this, ArrayInt.getCPtr(indices), indices);
  }

  public int addPoint(double aX, double aY) {
    return opensimCommonJNI.PiecewiseLinearFunction_addPoint(swigCPtr, this, aX, aY);
  }

  public double calcValue(Vector x) {
    return opensimCommonJNI.PiecewiseLinearFunction_calcValue(swigCPtr, this, Vector.getCPtr(x), x);
  }

  public double calcDerivative(StdVectorInt derivComponents, Vector x) {
    return opensimCommonJNI.PiecewiseLinearFunction_calcDerivative(swigCPtr, this, StdVectorInt.getCPtr(derivComponents), derivComponents, Vector.getCPtr(x), x);
  }

  public int getArgumentSize() {
    return opensimCommonJNI.PiecewiseLinearFunction_getArgumentSize(swigCPtr, this);
  }

  public int getMaxDerivativeOrder() {
    return opensimCommonJNI.PiecewiseLinearFunction_getMaxDerivativeOrder(swigCPtr, this);
  }

  public SWIGTYPE_p_SimTK__Function createSimTKFunction() {
    long cPtr = opensimCommonJNI.PiecewiseLinearFunction_createSimTKFunction(swigCPtr, this);
    return (cPtr == 0) ? null : new SWIGTYPE_p_SimTK__Function(cPtr, false);
  }

  public void updateFromXMLNode(SWIGTYPE_p_SimTK__Xml__Element aNode, int versionNumber) {
    opensimCommonJNI.PiecewiseLinearFunction_updateFromXMLNode__SWIG_0(swigCPtr, this, SWIGTYPE_p_SimTK__Xml__Element.getCPtr(aNode), versionNumber);
  }

  public void updateFromXMLNode(SWIGTYPE_p_SimTK__Xml__Element aNode) {
    opensimCommonJNI.PiecewiseLinearFunction_updateFromXMLNode__SWIG_1(swigCPtr, this, SWIGTYPE_p_SimTK__Xml__Element.getCPtr(aNode));
  }

}
