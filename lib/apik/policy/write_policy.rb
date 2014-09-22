# Copyright 2013-2014 Aerospike, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'apik/policy/policy'
require 'apik/policy/generation_policy'
require 'apik/policy/record_exists_action'

module Apik

  # Container object for client policy command.
  class WritePolicy < Policy

    attr_accessor :RecordExistsAction, :GenerationPolicy,
      :Generation, :Expiration, :SendKey

    def initialize(gen_policy=nil, generation=nil, expiration=nil)
      super()

      # Qualify how to handle writes where the record already exists.
      @RecordExistsAction = RecordExistsAction::UPDATE

      # Qualify how to handle record writes based on record generation. The default (NONE)
      # indicates that the generation is not used to restrict writes.
      @GenerationPolicy = gen_policy || GenerationPolicy::NONE

      # Expected generation. Generation is the number of times a record has been modified
      # (including creation) on the server. If a write operation is creating a record,
      # the expected generation would be 0
      @Generation = generation || 0

      # Record expiration. Also known as ttl (time to live).
      # Seconds record will live before being removed by the server.
      # Expiration values:
      # -1: Never expire for Aerospike 2 server versions >= 2.7.2 and Aerospike 3 server
      # versions >= 3.1.4.  Do not use -1 for older servers.
      # 0: Default to namespace configuration variable "default-ttl" on the server.
      # > 0: Actual expiration in seconds.
      @Expiration = expiration || 0

      # Send user defined key in addition to hash digest on a record put.
      # The default is to send the user defined key.
      @SendKey = true

      self
    end

  end # class

end # module
