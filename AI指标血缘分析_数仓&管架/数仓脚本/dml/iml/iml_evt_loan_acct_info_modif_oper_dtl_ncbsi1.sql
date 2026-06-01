/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_acct_info_modif_oper_dtl_ncbsi1
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
drop table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,seq_num -- 序号
    ,loan_num -- 贷款号
    ,modif_bus_cls_cd -- 变更业务分类代码
    ,modif_content_key_val -- 变更内容关键值
    ,acct_modif_cate_cd -- 账户变更类别代码
    ,modif_item -- 修改项
    ,modif_dt -- 变更日期
    ,modif_bf_val -- 变更前值
    ,modif_post_val -- 变更后值
    ,tran_org_id -- 交易机构编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,tran_descb -- 交易描述
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,modif_batch_no -- 变更批次号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_amend-1
insert into ${iml_schema}.evt_loan_acct_info_modif_oper_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,seq_num -- 序号
    ,loan_num -- 贷款号
    ,modif_bus_cls_cd -- 变更业务分类代码
    ,modif_content_key_val -- 变更内容关键值
    ,acct_modif_cate_cd -- 账户变更类别代码
    ,modif_item -- 修改项
    ,modif_dt -- 变更日期
    ,modif_bf_val -- 变更前值
    ,modif_post_val -- 变更后值
    ,tran_org_id -- 交易机构编号
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,tran_descb -- 交易描述
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,cust_id -- 客户编号
    ,tran_ref_no -- 交易参考号
    ,modif_batch_no -- 变更批次号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101021'||P1.AMEND_SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.AMEND_SEQ_NO -- 业务流水号
    ,P1.OB_AMEND_SEQ_NO -- 序号
    ,P1.LOAN_NO -- 贷款号
    ,P1.AMEND_BUSI_SORT -- 变更业务分类代码
    ,P1.AMEND_KEY -- 变更内容关键值
    ,P1.AMEND_TYPE -- 账户变更类别代码
    ,P1.AMEND_ITEM -- 修改项
    ,P1.AMEND_DATE -- 变更日期
    ,P1.BEFORE_VAL -- 变更前值
    ,P1.AFTER_VAL -- 变更后值
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,DECODE(P1.APPR_FLAG,'Y','1','N','0') -- 账户已复核标志
    ,P1.APPROVAL_DATE -- 复核日期
    ,P1.NARRATIVE -- 交易描述
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,P1.DD_NO -- 放款流水号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.AMEND_BATCH_NO -- 变更批次号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_amend' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_amend p1
where  1 = 1 
    and P1.AMEND_DATE=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_acct_info_modif_oper_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_acct_info_modif_oper_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_acct_info_modif_oper_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);