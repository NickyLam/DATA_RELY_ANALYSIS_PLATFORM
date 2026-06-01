/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_acct_oc_acct_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,flow_num -- 流水号
    ,lp_id -- 法人编号
    ,open_acct_org_id -- 开户机构编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,card_no -- 卡号
    ,acct_status_cd -- 账户状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_usage_cd -- 账户用途代码
    ,rs_descb -- 原因描述
    ,acct_attr_cd -- 账户属性代码
    ,acct_actv_dt -- 账户激活日期
    ,tran_ref_no -- 交易参考号
    ,advise_pbc_flg -- 通知人行标志
    ,oc_acct_oper_way_cd -- 开销户操作方式代码
    ,oc_acct_rgst_type_cd -- 开销户登记类型代码
    ,soci_unify_crdt_cd_flg -- 社会统一信用代码标志
    ,regard_same_self_flg -- 视同本人标志
    ,cust_cert_no -- 客户证件号码
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,apv_form_id -- 审批单编号
    ,fxq_tran_dt -- 反洗钱交易日期
    ,memo_code -- 摘要码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_acct_oc_acct_rgst_b
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_rb_open_close_reg-1
insert into ${iml_schema}.evt_dep_acct_oc_acct_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,flow_num -- 流水号
    ,lp_id -- 法人编号
    ,open_acct_org_id -- 开户机构编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,card_no -- 卡号
    ,acct_status_cd -- 账户状态代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_usage_cd -- 账户用途代码
    ,rs_descb -- 原因描述
    ,acct_attr_cd -- 账户属性代码
    ,acct_actv_dt -- 账户激活日期
    ,tran_ref_no -- 交易参考号
    ,advise_pbc_flg -- 通知人行标志
    ,oc_acct_oper_way_cd -- 开销户操作方式代码
    ,oc_acct_rgst_type_cd -- 开销户登记类型代码
    ,soci_unify_crdt_cd_flg -- 社会统一信用代码标志
    ,regard_same_self_flg -- 视同本人标志
    ,cust_cert_no -- 客户证件号码
    ,cust_id -- 客户编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,apv_form_id -- 审批单编号
    ,fxq_tran_dt -- 反洗钱交易日期
    ,memo_code -- 摘要码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101042'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 流水号
    ,'9999' -- 法人编号
    ,P1.OPEN_BRANCH -- 开户机构编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CARD_NO -- 卡号
    ,nvl(trim(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,P1.ACCT_TYPE -- 核心账户类型代码
    ,nvl(trim(P1.REASON_CODE),'-') -- 账户用途代码
    ,P1.REASON_CODE_DESC -- 原因描述
    ,nvl(trim(P1.ACCT_NATURE),'-') -- 账户属性代码
    ,P1.ACTIVE_DATE -- 账户激活日期
    ,P1.REFERENCE -- 交易参考号
    ,DECODE(TRIM(P1.INFORM_BANK_FLAG),'','-','Y','1','N','0',P1.INFORM_BANK_FLAG) -- 通知人行标志
    ,nvl(trim(P1.OP_METHOD),'-') -- 开销户操作方式代码
    ,P1.REG_TYPE -- 开销户登记类型代码
    ,DECODE(TRIM(P1.SUC_FLAG),'','-','Y','1','N','0',P1.SUC_FLAG) -- 社会统一信用代码标志
    ,DECODE(TRIM(P1.IS_SELF),'','-','Y','1','N','0',P1.IS_SELF) -- 视同本人标志
    ,P1.DOCUMENT_ID -- 客户证件号码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,P1.APPROVAL_NO -- 审批单编号
    ,${iml_schema}.timeformat_max(P1.EXTRA_TRAN_TIMESTAMP) -- 反洗钱交易日期
    ,P1.NARRATIVE_CODE -- 摘要码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_open_close_reg' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_open_close_reg p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no and p8.base_acct_no like '0%'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b truncate partition p_ncbsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_acct_oc_acct_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_acct_oc_acct_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_acct_oc_acct_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);