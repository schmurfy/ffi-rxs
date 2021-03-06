# encoding: utf-8

require File.join(File.dirname(__FILE__), %w[spec_helper])

module XS


  describe Context do

    context "when initializing with factory method #create" do
      include APIHelper

      it "should set the :pointer accessor to non-nil" do
        ctx = Context.create
        ctx.pointer.should_not be_nil
      end

      it "should set the :context accessor to non-nil" do
        ctx = Context.create
        ctx.context.should_not be_nil
      end

      it "should set the :pointer and :context accessors to the same value" do
        ctx = Context.create
        ctx.pointer.should == ctx.context
      end
      
      it "should define a finalizer on this object" do
        ObjectSpace.should_receive(:define_finalizer)
        ctx = Context.create
      end
    end # context initializing


    context "when initializing with #new" do
      include APIHelper

      it "should set the :pointer accessor to non-nil" do
        ctx = Context.new
        ctx.pointer.should_not be_nil
      end

      it "should set the :context accessor to non-nil" do
        ctx = Context.new
        ctx.context.should_not be_nil
      end

      it "should set the :pointer and :context accessors to the same value" do
        ctx = Context.new
        ctx.pointer.should == ctx.context
      end
      
      it "should define a finalizer on this object" do
        ObjectSpace.should_receive(:define_finalizer)
        ctx = Context.new
      end
    end # context initializing

    context "when setting context options" do
      include APIHelper
      
      it "should return unsuccessful code when option name is not recognized" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::IDENTITY, 10)
        Util.resultcode_ok?(rc).should be_false
      end
    end
    
    context "when setting IO_THREADS context option" do
      include APIHelper
      
      it "should return unsuccessful code for zero io threads" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::IO_THREADS, 0)
        Util.resultcode_ok?(rc).should be_false
      end
      
      it "should return unsuccessful code for negative io threads" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::IO_THREADS, -1)
        Util.resultcode_ok?(rc).should be_false
      end
      
      it "should return successful code for positive io threads" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::IO_THREADS, 10)
        Util.resultcode_ok?(rc).should be_true
      end
    end # context set IO_THREADS


    context "when setting MAX_SOCKETS context option" do
      include APIHelper
      
      it "should return successful code for zero max sockets" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::MAX_SOCKETS, 0)
        Util.resultcode_ok?(rc).should be_true
      end
      
      it "should return unsuccessful code for negative max sockets" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::MAX_SOCKETS, -1)
        Util.resultcode_ok?(rc).should be_false
      end
      
      it "should return successful code for positive max sockets" do
        ctx = Context.new
        rc = ctx.setctxopt(XS::MAX_SOCKETS, 100)
        Util.resultcode_ok?(rc).should be_true
      end
    end # context set MAX_SOCKETS

    context "when terminating" do
      it "should call xs_term to terminate the library's context" do
        ctx = Context.new # can't use a shared context here because we are terminating it!
        LibXS.should_receive(:xs_term).with(ctx.pointer).and_return(0)
        ctx.terminate
      end
    end # context terminate


    context "when allocating a socket" do
      it "should return nil when allocation fails" do
        ctx = Context.new
        LibXS.stub!(:xs_socket => nil)
        ctx.socket(XS::REQ).should be_nil
      end
    end # context socket

  end # describe Context


end # module XS
