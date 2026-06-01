/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_tran_acct_dtl_ncbsi1
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
drop table ${iml_schema}.evt_batch_tran_acct_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_batch_tran_acct_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_tran_acct_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_tran_acct_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,prod_id -- 产品编号
    ,subj_id -- 科目编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,heat_insu_acct_flg -- 医保账户标志
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,clear_dt -- 清算日期
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_type_cd -- 交易类型代码
    ,tran_descb -- 交易描述
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_postsc -- 交易附言
    ,cap_froz_flow_num -- 资金冻结流水号
    ,memo_code -- 摘要码
    ,memo -- 摘要
    ,cntpty_tran_type_cd -- 交易对手交易类型代码
    ,cntpty_tran_ref_no -- 交易对手交易参考号
    ,cntpty_tran_flow_num -- 交易对手交易流水号
    ,cntpty_subj_id -- 交易对手科目编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_curr_cd -- 交易对手账户币种代码
    ,cntpty_sub_acct_num -- 交易对手子账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,real_cntpty_cust_acct_num -- 真实交易对手客户账号
    ,real_cntpty_name -- 真实交易对手名称
    ,real_cntpty_acct_type_cd -- 真实交易对手账户类型代码
    ,real_cntpty_org_id -- 真实交易对手机构编号
    ,real_cntpty_org_name -- 真实交易对手机构名称
    ,real_cntpty_cert_no -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
    ,real_tran_happ_site -- 真实交易发生地点
    ,serv_status_descb -- 服务状态描述
    ,err_cd -- 错误码
    ,err_descb -- 错误描述
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_tran_acct_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_batch_tran_details-1
insert into ${iml_schema}.evt_batch_tran_acct_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_no -- 批次号
    ,seq_num -- 序号
    ,ova_flow_num -- 全局流水号
    ,chn_id -- 渠道编号
    ,cust_acct_num -- 客户账号
    ,cust_type_cd -- 客户类型代码
    ,prod_id -- 产品编号
    ,subj_id -- 科目编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,heat_insu_acct_flg -- 医保账户标志
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,clear_dt -- 清算日期
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_type_cd -- 交易类型代码
    ,tran_descb -- 交易描述
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_postsc -- 交易附言
    ,cap_froz_flow_num -- 资金冻结流水号
    ,memo_code -- 摘要码
    ,memo -- 摘要
    ,cntpty_tran_type_cd -- 交易对手交易类型代码
    ,cntpty_tran_ref_no -- 交易对手交易参考号
    ,cntpty_tran_flow_num -- 交易对手交易流水号
    ,cntpty_subj_id -- 交易对手科目编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_prod_id -- 交易对手账户产品编号
    ,cntpty_acct_curr_cd -- 交易对手账户币种代码
    ,cntpty_sub_acct_num -- 交易对手子账号
    ,cntpty_acct_name -- 交易对手账户名称
    ,real_cntpty_cust_acct_num -- 真实交易对手客户账号
    ,real_cntpty_name -- 真实交易对手名称
    ,real_cntpty_acct_type_cd -- 真实交易对手账户类型代码
    ,real_cntpty_org_id -- 真实交易对手机构编号
    ,real_cntpty_org_name -- 真实交易对手机构名称
    ,real_cntpty_cert_no -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
    ,real_tran_happ_site -- 真实交易发生地点
    ,serv_status_descb -- 服务状态描述
    ,err_cd -- 错误码
    ,err_descb -- 错误描述
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401047'||P1.BATCH_NO||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_NO -- 批次号
    ,P1.SEQ_NO -- 序号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,nvl(trim(P1.SOURCE_TYPE),'0000') -- 渠道编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,nvl(trim(P1.CLIENT_TYPE),'-') -- 客户类型代码
    ,P1.PROD_TYPE -- 产品编号
    ,P1.GL_CODE -- 科目编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,nvl(trim(P1.MED_INS_TRAN_FLAG),'-') -- 医保账户标志
    ,P1.ACCT_DESC -- 账户名称
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.SETTLEMENT_DATE -- 清算日期
    ,P1.REFERENCE -- 交易参考号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_AMT -- 交易金额
    ,nvl(trim(P1.BATCH_STATUS),'-') -- 交易状态代码
    ,nvl(trim(P1.TRAN_TYPE),'-') -- 交易类型代码
    ,P1.TRAN_DESC -- 交易描述
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_NOTE -- 交易附言
    ,P1.FH_SEQ_NO -- 资金冻结流水号
    ,nvl(trim(P1.NARRATIVE_CODE),'-') -- 摘要码
    ,P1.NARRATIVE -- 摘要
    ,nvl(trim(P1.OTH_TRAN_TYPE),'-') -- 交易对手交易类型代码
    ,P1.OTH_REFERENCE -- 交易对手交易参考号
    ,P1.OTH_SEQ_NO -- 交易对手交易流水号
    ,P1.OTH_GL_CODE -- 交易对手科目编号
    ,P1.OTH_TRAN_NAME -- 交易对手名称
    ,P1.OTH_BRANCH -- 交易对手开户机构编号
    ,P1.OTH_BASE_ACCT_NO -- 交易对手账户编号
    ,P1.OTH_PROD_TYPE -- 交易对手账户产品编号
    ,nvl(trim(P1.OTH_ACCT_CCY),'-') -- 交易对手账户币种代码
    ,P1.OTH_ACCT_SEQ_NO -- 交易对手子账号
    ,P1.OTH_ACCT_DESC -- 交易对手账户名称
    ,P1.OTH_REAL_BASE_ACCT_NO -- 真实交易对手客户账号
    ,P1.OTH_REAL_TRAN_NAME -- 真实交易对手名称
    ,P1.OTH_REAL_PROD_TYPE -- 真实交易对手账户类型代码
    ,P1.OTH_REAL_BANK_CODE -- 真实交易对手机构编号
    ,P1.OTH_REAL_BANK_NAME -- 真实交易对手机构名称
    ,P1.OTH_REAL_DOCUMENT_ID -- 真实交易对手证件号码
    ,P1.OTH_REAL_DOCUMENT_TYPE -- 真实交易对手证件类型代码
    ,P1.OTH_REAL_TRAN_ADDR -- 真实交易发生地点
    ,P1.RET_MSG -- 服务状态描述
    ,P1.ERROR_CODE -- 错误码
    ,P1.ERROR_DESC -- 错误描述
    ,P1.REMARK1 -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_batch_tran_details' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_batch_tran_details p1
where  1 = 1 
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_batch_tran_acct_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_tran_acct_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_batch_tran_acct_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_tran_acct_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_tran_acct_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_tran_acct_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);