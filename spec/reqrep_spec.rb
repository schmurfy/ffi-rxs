# encoding: utf-8

require File.join(File.dirname(__FILE__), %w[spec_helper])

module XS


  describe Context do

    context "when running ping pong" do
      include APIHelper

      let(:string) { "booga-booga" }

      before(:each) do
        context = XS::Context.new
        @ping = context.socket XS::REQ
        @pong = context.socket XS::REP
        port = bind_to_random_tcp_port(@pong)
        @ping.connect "tcp://127.0.0.1:#{port}"
      end

      after(:each) do
        @ping.close
        @pong.close
      end

      it "should receive an exact string copy of the string message sent" do
        @ping.send_string string
        received_message = ''
        rc = @pong.recv_string received_message

        received_message.should == string
      end

      it "should receive an exact copy of the sent message using Message objects directly" do
        sent_message = Message.new string
        received_message = Message.new

        rc = @ping.sendmsg sent_message
        rc.should == string.size
        rc = @pong.recvmsg received_message
        rc.should == string.size

        received_message.copy_out_string.should == string
      end

      it "should receive an exact copy of the sent message using Message objects directly in non-blocking mode" do
        sent_message = Message.new string
        received_message = Message.new

        rc = @ping.sendmsg sent_message, XS::NonBlocking
        rc.should == string.size
        sleep 0.01 # give it time for delivery
        rc = @pong.recvmsg received_message, XS::NonBlocking
        rc.should == string.size

        received_message.copy_out_string.should == string
      end

    end # context ping-pong


  end # describe


end # module XS
