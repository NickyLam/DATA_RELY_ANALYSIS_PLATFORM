/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans1_v_tbgrpchildtransreq
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq_ex purge;
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq_ex nologging
compress
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq_ex(
    serial_no -- 流水序号:流水号
    ,ex_serial -- 原始请求外部流水号
    ,model -- 模式
    ,trans_code -- 交易代码
    ,group_code -- 分组代码
    ,prd_type -- 产品类型:1-基金
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,child_serial_no -- 子流水号
    ,sub_trans_code -- 子交易编号
    ,prd_code -- 产品代码
    ,amt -- 金额
    ,vol -- 份额
    ,cfm_vol -- 确认份额
    ,cfm_amt -- 确认金额
    ,fee -- 手续费
    ,err_code -- 错误代码
    ,err_msg -- 错误信息
    ,child_status -- 子交易状态:0-预受理  		  1-受理  		  2-已撤单  		  3-已抹账  		  4-失败  		  5-已导出  		  6-部分确认未全部返回  		  7-部分确认已全部返回  		  8-确认成功  		  9-确认失败  		  a-认购确认  		  b-份额调账  		  c-待撤销  		  d-分红数据  		  e-预约中  		  f-预受理处理失败  		  s-成功  		  z-处理中  		  p-待审批  		  w-已审批，待确认  		  t-超时  		  g-调仓中，交易待发起  		  h-调仓已导出  		  i-待发起  		  j-已审批  		  k-交易待导出给基金代销  		  l-已补处理  		  m-交易已导出给基金代销待确认
    ,summary -- 摘要
    ,to_host_serial -- 发送主机流水号
    ,check_date -- 对账日期
    ,ori_host_chk_date -- 原交易主机对账日期
    ,host_trans_code -- 主机交易码
    ,host_date -- 核心日期:主机日期
    ,host_serial -- 主机流水号
    ,liqu_status -- 账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,reserve4 -- 保留字段4
    ,reserve5 -- 保留字段5
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,amt4 -- 备用金额4
    ,amt5 -- 备用金额5
    ,amt6 -- 备用金额6
    ,cancel_date -- 撤单日期
    ,cancel_time -- 撤单时间
    ,cfm_fee -- 确认手续费
    ,cfm_nav -- 确认净值
    ,double1 -- 扩展浮点数1
    ,double2 -- 备用double2
    ,double3 -- 备用double3
    ,double4 -- 备用double4
    ,double5 -- 备用double5
    ,asso_serial -- 关联流水号
    ,asso_serial2 -- 关联流水号2
    ,asso_serial3 -- 关联流水号3
    ,agio -- 折扣率
    ,square_date -- 清算日期:原入账日期，跟公司统一名称改为清算日期
    ,in_client_no -- 内部客户编号
    ,phy_date -- 物理日期
    ,modify_timestamp -- 修改时间戳
    ,cancel_amt -- 撤单金额
    ,cfm_date -- 确认日期
    ,client_manager -- 客户经理
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serial_no -- 流水序号:流水号
    ,ex_serial -- 原始请求外部流水号
    ,model -- 模式
    ,trans_code -- 交易代码
    ,group_code -- 分组代码
    ,prd_type -- 产品类型:1-基金
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,child_serial_no -- 子流水号
    ,sub_trans_code -- 子交易编号
    ,prd_code -- 产品代码
    ,amt -- 金额
    ,vol -- 份额
    ,cfm_vol -- 确认份额
    ,cfm_amt -- 确认金额
    ,fee -- 手续费
    ,err_code -- 错误代码
    ,err_msg -- 错误信息
    ,child_status -- 子交易状态:0-预受理  		  1-受理  		  2-已撤单  		  3-已抹账  		  4-失败  		  5-已导出  		  6-部分确认未全部返回  		  7-部分确认已全部返回  		  8-确认成功  		  9-确认失败  		  a-认购确认  		  b-份额调账  		  c-待撤销  		  d-分红数据  		  e-预约中  		  f-预受理处理失败  		  s-成功  		  z-处理中  		  p-待审批  		  w-已审批，待确认  		  t-超时  		  g-调仓中，交易待发起  		  h-调仓已导出  		  i-待发起  		  j-已审批  		  k-交易待导出给基金代销  		  l-已补处理  		  m-交易已导出给基金代销待确认
    ,summary -- 摘要
    ,to_host_serial -- 发送主机流水号
    ,check_date -- 对账日期
    ,ori_host_chk_date -- 原交易主机对账日期
    ,host_trans_code -- 主机交易码
    ,host_date -- 核心日期:主机日期
    ,host_serial -- 主机流水号
    ,liqu_status -- 账务状态:[k_zwzt] 0	-	账务无关 1	-	待冻结 2	-	待扣款 3	-	已冻结 4	-	已扣款 5	-	待解冻扣款 6	-	已上账 7	-	待上账 8	-	已解冻 9	-	上账并冻结
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,reserve4 -- 保留字段4
    ,reserve5 -- 保留字段5
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,amt4 -- 备用金额4
    ,amt5 -- 备用金额5
    ,amt6 -- 备用金额6
    ,cancel_date -- 撤单日期
    ,cancel_time -- 撤单时间
    ,cfm_fee -- 确认手续费
    ,cfm_nav -- 确认净值
    ,double1 -- 扩展浮点数1
    ,double2 -- 备用double2
    ,double3 -- 备用double3
    ,double4 -- 备用double4
    ,double5 -- 备用double5
    ,asso_serial -- 关联流水号
    ,asso_serial2 -- 关联流水号2
    ,asso_serial3 -- 关联流水号3
    ,agio -- 折扣率
    ,square_date -- 清算日期:原入账日期，跟公司统一名称改为清算日期
    ,in_client_no -- 内部客户编号
    ,phy_date -- 物理日期
    ,modify_timestamp -- 修改时间戳
    ,cancel_amt -- 撤单金额
    ,cfm_date -- 确认日期
    ,client_manager -- 客户经理
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_hstctrans1_v_tbgrpchildtransreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq exchange partition p_${batch_date} with table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpchildtransreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans1_v_tbgrpchildtransreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);