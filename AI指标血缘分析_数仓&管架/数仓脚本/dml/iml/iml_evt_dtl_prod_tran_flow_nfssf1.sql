/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dtl_prod_tran_flow_nfssf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_dtl_prod_tran_flow_nfssf1_tm purge;
alter table ${iml_schema}.evt_dtl_prod_tran_flow add partition p_nfssf1 values ('nfssf1')(
        subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dtl_prod_tran_flow modify partition p_nfssf1
    add subpartition p_nfssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dtl_prod_tran_flow_nfssf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,ext_flow_num -- 外部流水号
    ,dtl_prod_id -- 明细产品编号
    ,comb_prod_id -- 组合产品编号
    ,intnal_cust_id -- 内部客户编号
    ,tran_cd -- 交易代码
    ,prod_type_cd -- 产品类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,sub_flow_num -- 子流水号
    ,sub_tran_cd -- 子交易代码
    ,sub_tran_status_cd -- 子交易状态代码
    ,fin_status_cd -- 财务状态代码
    ,amt -- 金额
    ,lot -- 份额
    ,comm_fee -- 手续费
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,cfm_nv -- 确认净值
    ,cfm_comm_fee -- 确认手续费
    ,cfm_dt -- 确认日期
    ,revo_amt -- 撤单金额
    ,revo_dt -- 撤单日期
    ,revo_tm -- 撤单时间
    ,discnt_rat -- 折扣率
    ,clear_dt -- 清算日期
    ,check_entry_dt -- 对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_flow_num -- 主机流水号
    ,send_host_flow_num -- 发送主机流水号
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,init_tran_flow_num -- 原交易流水号
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,memo_comnt -- 摘要说明
    ,cust_mgr_id -- 客户经理编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dtl_prod_tran_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- nfss_hstctrans1_v_tbhisgrpchildtransreq-1
insert into ${iml_schema}.evt_dtl_prod_tran_flow_nfssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,ext_flow_num -- 外部流水号
    ,dtl_prod_id -- 明细产品编号
    ,comb_prod_id -- 组合产品编号
    ,intnal_cust_id -- 内部客户编号
    ,tran_cd -- 交易代码
    ,prod_type_cd -- 产品类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,sub_flow_num -- 子流水号
    ,sub_tran_cd -- 子交易代码
    ,sub_tran_status_cd -- 子交易状态代码
    ,fin_status_cd -- 财务状态代码
    ,amt -- 金额
    ,lot -- 份额
    ,comm_fee -- 手续费
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,cfm_nv -- 确认净值
    ,cfm_comm_fee -- 确认手续费
    ,cfm_dt -- 确认日期
    ,revo_amt -- 撤单金额
    ,revo_dt -- 撤单日期
    ,revo_tm -- 撤单时间
    ,discnt_rat -- 折扣率
    ,clear_dt -- 清算日期
    ,check_entry_dt -- 对账日期
    ,init_tran_host_check_entry_dt -- 原交易主机对账日期
    ,host_flow_num -- 主机流水号
    ,send_host_flow_num -- 发送主机流水号
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,init_tran_flow_num -- 原交易流水号
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,memo_comnt -- 摘要说明
    ,cust_mgr_id -- 客户经理编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401023'||P1.SERIAL_NO||P1.EX_SERIAL||P1.PRD_CODE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 流水号
    ,P1.EX_SERIAL -- 外部流水号
    ,P1.PRD_CODE -- 明细产品编号
    ,P1.GROUP_CODE -- 组合产品编号
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,NVL(TRIM(P1.TRANS_CODE),'-') -- 交易代码
    ,NVL(TRIM(P1.PRD_TYPE),'-') -- 产品类型代码
    ,${iml_schema}.dateformat_max2(P1.TRANS_DATE) -- 交易日期
    ,${iml_schema}.timeformat_min(P1.TRANS_DATE||P1.TRANS_TIME) -- 交易时间
    ,P1.CHILD_SERIAL_NO -- 子流水号
    ,NVL(TRIM(P1.SUB_TRANS_CODE),'-') -- 子交易代码
    ,NVL(TRIM(P1.CHILD_STATUS),'-') -- 子交易状态代码
    ,NVL(TRIM(P1.LIQU_STATUS),'-') -- 财务状态代码
    ,P1.AMT -- 金额
    ,P1.VOL -- 份额
    ,P1.FEE -- 手续费
    ,P1.CFM_AMT -- 确认金额
    ,P1.CFM_VOL -- 确认份额
    ,P1.CFM_NAV -- 确认净值
    ,P1.CFM_FEE -- 确认手续费
    ,${iml_schema}.dateformat_max2(P1.CFM_DATE) -- 确认日期
    ,P1.CANCEL_AMT -- 撤单金额
    ,${iml_schema}.dateformat_min(P1.CANCEL_DATE) -- 撤单日期
    ,${iml_schema}.timeformat_max(P1.CANCEL_DATE||P1.CANCEL_TIME) -- 撤单时间
    ,P1.AGIO -- 折扣率
    ,${iml_schema}.dateformat_max2(P1.SQUARE_DATE) -- 清算日期
    ,${iml_schema}.dateformat_max2(P1.CHECK_DATE) -- 对账日期
    ,${iml_schema}.dateformat_min(P1.ORI_HOST_CHK_DATE) -- 原交易主机对账日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.TO_HOST_SERIAL -- 发送主机流水号
    ,P1.HOST_TRANS_CODE -- 主机交易码
    ,${iml_schema}.dateformat_min(P1.HOST_DATE) -- 主机日期
    ,P1.ASSO_SERIAL -- 原交易流水号
    ,P1.ERR_CODE -- 错误码
    ,P1.ERR_MSG -- 错误信息描述
    ,P1.SUMMARY -- 摘要说明
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_hstctrans1_v_tbhisgrpchildtransreq' -- 源表名称
    ,'nfssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_hstctrans1_v_tbhisgrpchildtransreq p1
where  1 = 1 
;
commit;


-- 3.2 truncate target table
alter table ${iml_schema}.evt_dtl_prod_tran_flow truncate partition p_nfssf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dtl_prod_tran_flow exchange subpartition p_nfssf1_${batch_date} with table ${iml_schema}.evt_dtl_prod_tran_flow_nfssf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dtl_prod_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dtl_prod_tran_flow_nfssf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dtl_prod_tran_flow', partname => 'p_nfssf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);