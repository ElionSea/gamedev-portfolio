/*
		{
		 * @private
		 */
		protected function createBulkProgress(bf:IBulkFile):BulkProgress
		{
			if (weightTotal == 0) _bulkProgress._weightedPercentage = 0;