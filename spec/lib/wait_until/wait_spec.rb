describe WaitUntil::Wait do

  before(:all) do
    @initial_default_timeout = WaitUntil::Wait.default_timeout_in_seconds
    WaitUntil::Wait.default_timeout_in_seconds = 1
  end

  after(:all) { WaitUntil::Wait.default_timeout_in_seconds = @initial_default_timeout }

  describe ".until_true!" do

    describe "when the block returns true" do

      it "should execute without error" do
        lambda { WaitUntil::Wait.until_true!("some operation") { true } }.should_not raise_error
      end

    end

    describe "when the blocks always returns false" do

      it "should raise an error indicating the operation timed-out" do
        lambda do
          WaitUntil::Wait.until_true!("another operation finishes") { false }
        end.should raise_error(/Timed-out waiting until 'another operation finishes'/i)
      end

    end

    describe "when the block eventually returns true" do

      it "should execute without error" do
        invocation_count = 0
        lambda do
          WaitUntil::Wait.until_true!("some operation") do
            invocation_count += 1
            invocation_count == 3
          end
        end.should_not raise_error
      end

    end

  end

  describe ".until_false!" do

    describe "when the block returns false" do

      it "should execute without error" do
        lambda { WaitUntil::Wait.until_false!("some operation") { false } }.should_not raise_error
      end

    end

    describe "when the blocks always returns true" do

      it "should raise an error indicating the operation timed-out" do
        lambda do
          WaitUntil::Wait.until_false!("another operation finishes") { true }
        end.should raise_error(/Timed-out waiting until 'another operation finishes'/i)
      end

    end

    describe "when the block eventually returns false" do

      it "should execute without error" do
        invocation_count = 0
        lambda do
          WaitUntil::Wait.until_false!("some operation") do
            invocation_count += 1
            invocation_count < 3
          end
        end.should_not raise_error
      end

    end

  end

  describe ".until!" do

    describe "when the block executes without error" do

      it "should execute without error" do
        lambda { WaitUntil::Wait.until!("some operation") { } }.should_not raise_error
      end

    end

    describe "when the block raises an error indefinitely" do

      it "should raise an error indicating the operation timed-out" do
        lambda do
          WaitUntil::Wait.until!("some operation finishes") do
            raise "forced error"
          end
        end.should raise_error(/Timed-out waiting until 'some operation finishes'/i)
      end

    end

    describe "when the block eventually executes without error" do

      it "should execute without error" do
        invocation_count = 0
        lambda do
          WaitUntil::Wait.until!("some operation") do
            invocation_count += 1
            raise "forced error" if invocation_count < 3
          end
        end.should_not raise_error
      end

    end

  end

end
