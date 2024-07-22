/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.2
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package org.opensim.modeling;

/**
 *  <br>
 * This file defines the client side of the SimTK::Matrix classes, which<br>
 * hold medium to large, variable-sized matrices whose elements are packed <br>
 * SimTK "Composite Numerical Types" (CNTs). Unlike CNTs, the implemention here <br>
 * is opaque, and almost all properties are captured in the implementation at <br>
 * run time rather than in the type at compile time. <br>
 * <br>
 * Every Matrix consists logically of three pieces: <br>
 *  - the matrix handle <br>
 *  - the matrix helper<br>
 *  - and the matrix data. <br>
 * <br>
 * They are organized like this:<br>
 * <pre><br>
 *      ------------            ------------<br>
 *     |  Handle&lt;E&gt; | -------&gt; |            |<br>
 *      ------------  &lt;------- | Helper&lt;S&gt;  |<br>
 *                             |            |<br>
 *                             |            |          --------~ ~--<br>
 *                             |            | ------&gt; | Data&lt;S&gt; ... |<br>
 *                              ------------           --------~ ~--<br>
 * </pre><br>
 * The handle is the object actually appearing in SimTK API user programs.<br>
 * It always consists of just a single pointer, pointing to a library-side<br>
 * "helper" object whose implementation is opaque. The handle is templatized<br>
 * by the user's element type, which may be any packed composite numerical<br>
 * type, including scalar types like <code>float</code> and <code>complex</code>&lt;double&gt;, but also<br>
 * composite types such as <code>Vec3</code> or <code>Mat</code>&lt;2,2,Mat<3,3&gt;&gt;. A Matrix handle<br>
 * owns the helper to which it points and must destruct the helper when<br>
 * the handle's destructor is called.<br>
 * <br>
 * The helper, on the other hand, is parameterized only by the underlying scalar <br>
 * type. There are exactly 12 SimTK scalar types, so all can be instantiated on <br>
 * the library side leaving the implementation opaque and thus flexible from<br>
 * release to release without compromising binary compatibility. (The scalar <br>
 * types are: the four C++ standard types float and double, <br>
 * complex&lt;float&gt;, and complex&lt;double&gt;; the SimTK numbers conjugate&lt;float&gt; and <br>
 * conjugate&lt;double&gt;; and negator&lt;&gt; types templatized by any of the six<br>
 * numeric types.) The helper contains several kinds of information:<br>
 *  - the underlying scalar type S (as its template parameter)<br>
 *  - the number of scalars in the handle's logical element type E<br>
 *  - whether this is an owner matrix, or just a view<br>
 *  - the handle "commitment"; defining the range of matrix characteristics<br>
 *      to which that handle may refer<br>
 *  - the actual characteristics of the matrix currently represented by<br>
 *      the helper<br>
 *  - a virtual function table full of methods which are aware of the<br>
 *      logical structure of the Matrix and the physical structure of <br>
 *      the data to support operations such as element indexing<br>
 *  - a pointer to the underlying data, which may be shared with other <br>
 *      helpers<br>
 * <br>
 * The data itself consists only of scalars<br>
 * S of the same type as the helper's template argument, but different <br>
 * helpers can look at the same data differently. For examples, when the<br>
 * elements are composite consisting of k scalars, the helper will provide a <br>
 * view of the data in which its scalars are interpreted in groups of k.<br>
 * Many other reinterpretations of the data are possible and useful, such<br>
 * as a real-valued helper viewing only the real or imaginary part of<br>
 * complex data, or a helper which views the data order as though it were<br>
 * transposed.<br>
 * <br>
 * At most <i>one</i> matrix helper owns the matrix data and is responsible<br>
 * for deleting that data when no longer needed. That is called an "owner"<br>
 * helper and its associated handle is an owner handle. Normally the owner <br>
 * is the handle (and helper) that allocated the data, and<br>
 * in most cases an owner can resize the data at will. Many other handles<br>
 * may reference the same data; those non-owner handles are called "views".<br>
 * Every view may present a different picture of the underlying data. The<br>
 * default view is "whole" meaning that all the elements of the data are <br>
 * visible, and appear in their normal order. A "transpose" view also shows <br>
 * all the elements but the matrix dimensions and indices are reversed. <br>
 * Other common views are "block" to select a sub-block of a matrix, and <br>
 * "diagonal" which shows only the diagonal of a matrix (as a vector). <br>
 * <br>
 * NOTE: Destruction of an owner destructs the data it owns<br>
 * *regardless* of the presence of other views into that data! I.e., these<br>
 * are not reference counted. TODO: should we change that?<br>
 * <br>
 * In some cases there may be no owner helper for a particular piece of <br>
 * matrix data. That occurs when pre-existing memory, such as a Fortran<br>
 * array, is used to construct a Matrix. In that case all the helpers are<br>
 * views and the data will persist after the destruction of the last<br>
 * referencing helper.<br>
 * <br>
 * A Matrix that is the owner of its data will be resized whenever<br>
 * necessary, unless you take active steps to prevent that. For example, if<br>
 * you declare a Vector, the number of rows can resize but the number of<br>
 * columns will be locked at 1. A RowVector does the reverse. You can also<br>
 * explicitly lock the number of rows and/or columns of a matrix to prevent<br>
 * unwanted resizes.<br>
 * <br>
 * Here are the classes and short descriptions:<br>
 * <pre><br>
 *   MatrixHelper&lt;S&gt;  interface to the opaque implementation, templatized<br>
 *                      by scalar type only<br>
 *   MatrixBase&lt;CNT&gt;  fully templatized client, contains a MatrixHelper<br>
 * </pre><br>
 * <br>
 * The rest are dataless classes all of which can be interconverted just<br>
 * by recasting. Every one of these classes has a default conversion to<br>
 * type Matrix_&lt;same element type&gt;, so users can write functions that expect<br>
 * a Matrix argument and pass it a Vector, RowVectorView, or whatever.<br>
 * <br>
 * <pre><br>
 *   VectorBase&lt;CNT&gt;    these are derived from MatrixBase and add no new data,<br>
 *   RowVectorBase&lt;CNT&gt; but change some of the operators and other methods to<br>
 *                        be appropriate for 1d data.<br>
 * <br>
 *   Matrix_&lt;CNT&gt;      2d owner class     (a MatrixBase&lt;CNT&gt;)<br>
 *   Vector_&lt;CNT&gt;      column owner class (a VectorBase&lt;CNT&gt;)<br>
 *   RowVector_&lt;CNT&gt;   row owner class    (a RowVectorBase&lt;CNT&gt;)<br>
 * </pre><br>
 * <br>
 * Views are exactly the same as the corresponding owner class, but with<br>
 * shallow construction and assignment semantics.<br>
 * <br>
 * <pre><br>
 *   MatrixView_&lt;CNT&gt;, VectorView_&lt;CNT&gt;, RowVectorView_&lt;CNT&gt;<br>
 * </pre><br>
 * <br>
 * Dead matrices are owners that are about to be destructed. Anything<br>
 * they own may be taken from them, including the helper and/or<br>
 * the data. This is a very effective performance trick for sequences<br>
 * of operations since it eliminates most of the need for allocating and<br>
 * deallocating temporaries.<br>
 * <br>
 * <pre><br>
 *   DeadMatrix_&lt;CNT&gt;, DeadVector_&lt;CNT&gt;, DeadRowVector_&lt;CNT&gt;<br>
 * </pre>
 */
public class MatrixBaseVec3 {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  public MatrixBaseVec3(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  public static long getCPtr(MatrixBaseVec3 obj) {
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
        opensimSimbodyJNI.delete_MatrixBaseVec3(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  /**
   *  Return the number of rows m in the logical shape of this matrix.
   */
  public int nrow() {
    return opensimSimbodyJNI.MatrixBaseVec3_nrow(swigCPtr, this);
  }

  /**
   *  Return the number of columns n in the logical shape of this matrix.
   */
  public int ncol() {
    return opensimSimbodyJNI.MatrixBaseVec3_ncol(swigCPtr, this);
  }

  /**
   *  Return true if either dimension of this Matrix is resizable.
   */
  public boolean isResizeable() {
    return opensimSimbodyJNI.MatrixBaseVec3_isResizeable(swigCPtr, this);
  }

  /**
   *  The default constructor builds a 0x0 matrix managed by a helper that<br>
   *  understands how many scalars there are in one of our elements but is<br>
   *  otherwise uncommitted.
   */
  public MatrixBaseVec3() {
    this(opensimSimbodyJNI.new_MatrixBaseVec3__SWIG_0(), true);
  }

  /**
   *  This constructor allocates the default matrix a completely uncommitted<br>
   *  matrix commitment, given particular initial dimensions.
   */
  public MatrixBaseVec3(int m, int n) {
    this(opensimSimbodyJNI.new_MatrixBaseVec3__SWIG_1(m, n), true);
  }

  /**
   *  This restores the MatrixBase to the state it would be in had it<br>
   *  been constructed specifying only its handle commitment. The size will<br>
   *  have been reduced to the smallest size consistent with the commitment.
   */
  public void clear() {
    opensimSimbodyJNI.MatrixBaseVec3_clear(swigCPtr, this);
  }

  /**
   *  Fill every element in current allocation with given element (or NaN or 0).
   */
  public MatrixBaseVec3 setTo(Vec3 t) {
    return new MatrixBaseVec3(opensimSimbodyJNI.MatrixBaseVec3_setTo(swigCPtr, this, Vec3.getCPtr(t), t), false);
  }

  public MatrixBaseVec3 setToNaN() {
    return new MatrixBaseVec3(opensimSimbodyJNI.MatrixBaseVec3_setToNaN(swigCPtr, this), false);
  }

  public MatrixBaseVec3 setToZero() {
    return new MatrixBaseVec3(opensimSimbodyJNI.MatrixBaseVec3_setToZero(swigCPtr, this), false);
  }

  public RowVectorViewVec3 row(int i) {
    return new RowVectorViewVec3(opensimSimbodyJNI.MatrixBaseVec3_row(swigCPtr, this, i), true);
  }

  public RowVectorViewVec3 updRow(int i) {
    return new RowVectorViewVec3(opensimSimbodyJNI.MatrixBaseVec3_updRow(swigCPtr, this, i), true);
  }

  public VectorViewVec3 col(int j) {
    return new VectorViewVec3(opensimSimbodyJNI.MatrixBaseVec3_col(swigCPtr, this, j), true);
  }

  public VectorViewVec3 updCol(int j) {
    return new VectorViewVec3(opensimSimbodyJNI.MatrixBaseVec3_updCol(swigCPtr, this, j), true);
  }

  /**
   *  Element selection for stored elements. These are the fastest element access<br>
   *  methods but may not be able to access all elements of the logical matrix when<br>
   *  some of its elements are not stored in memory. For example, a Hermitian matrix<br>
   *  stores only half its elements and other ones have to be calculated by conjugation<br>
   *  if they are to be returned as type ELT. (You can get them for free by recasting<br>
   *  the matrix so that the elements are reinterpreted as conjugates.) If you want<br>
   *  to guarantee that you can access the value of every element of a matrix, stored or not,<br>
   *  use getAnyElt() instead.
   */
  public Vec3 getElt(int i, int j) {
    return new Vec3(opensimSimbodyJNI.MatrixBaseVec3_getElt(swigCPtr, this, i, j), false);
  }

  public Vec3 updElt(int i, int j) {
    return new Vec3(opensimSimbodyJNI.MatrixBaseVec3_updElt(swigCPtr, this, i, j), false);
  }

  public MatrixBaseVec3 negateInPlace() {
    return new MatrixBaseVec3(opensimSimbodyJNI.MatrixBaseVec3_negateInPlace(swigCPtr, this), false);
  }

  /**
   *  Change the size of this matrix. This is only allowed for owner matrices. The<br>
   *  current storage format is retained, but all the data is lost. If you want<br>
   *  to keep the old data, use resizeKeep().<br>
   *  @see resizeKeep()
   */
  public MatrixBaseVec3 resize(int m, int n) {
    return new MatrixBaseVec3(opensimSimbodyJNI.MatrixBaseVec3_resize(swigCPtr, this, m, n), false);
  }

  /**
   *  Change the size of this matrix, retaining as much of the old data as will<br>
   *  fit. This is only allowed for owner matrices. The<br>
   *  current storage format is retained, and the existing data is copied<br>
   *  into the new memory to the extent that it will fit.<br>
   *  @see resize()
   */
  public MatrixBaseVec3 resizeKeep(int m, int n) {
    return new MatrixBaseVec3(opensimSimbodyJNI.MatrixBaseVec3_resizeKeep(swigCPtr, this, m, n), false);
  }

  public void lockShape() {
    opensimSimbodyJNI.MatrixBaseVec3_lockShape(swigCPtr, this);
  }

  public void unlockShape() {
    opensimSimbodyJNI.MatrixBaseVec3_unlockShape(swigCPtr, this);
  }

  public final static int NScalarsPerElement = opensimSimbodyJNI.MatrixBaseVec3_NScalarsPerElement_get();
  public final static int CppNScalarsPerElement = opensimSimbodyJNI.MatrixBaseVec3_CppNScalarsPerElement_get();

}
