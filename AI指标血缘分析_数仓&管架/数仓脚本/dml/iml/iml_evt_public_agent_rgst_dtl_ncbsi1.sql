/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_public_agent_rgst_dtl_ncbsi1
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
drop table ${iml_schema}.evt_public_agent_rgst_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_public_agent_rgst_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_public_agent_rgst_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_public_agent_rgst_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,ova_flow_num -- 全局流水号
    ,lp_id -- 法人编号
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_cd -- 交易码
    ,agent_evt_cate_id -- 代办事件类别编号
    ,tran_amt -- 交易金额
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,bus_vouch_no -- 业务凭证号码
    ,cust_id -- 客户编号
    ,public_agent_name -- 代办人名称
    ,public_agent_cust_id -- 代办人客户编号
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_licen_issue_autho_cty_rg_cd -- 代办人发证机关国家和地区代码
    ,public_agent_cert_effect_dt -- 代办人证件生效日期
    ,public_agent_cert_invalid_dt -- 代办人证件失效日期
    ,public_agent_tel_num -- 交易代办人联系电话
    ,agent_reason -- 代办理由
    ,public_agent_rela -- 代办人关系
    ,tran_tm -- 交易时间
    ,agent_vrif_emply_a_id -- 代办核实员工A编号
    ,agent_vrif_emply_b_id -- 代办核实员工B编号
    ,vrif_ps_tel_num -- 被核实人电话号码
    ,vrif_tm -- 核实时间
    ,vrif_rest -- 核实结果
    ,agent_idf_cd -- 代理标识代码
    ,public_agent_flg -- 代办人标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_public_agent_rgst_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_commission_register-1
insert into ${iml_schema}.evt_public_agent_rgst_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,ova_flow_num -- 全局流水号
    ,lp_id -- 法人编号
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_cd -- 交易码
    ,agent_evt_cate_id -- 代办事件类别编号
    ,tran_amt -- 交易金额
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,bus_vouch_no -- 业务凭证号码
    ,cust_id -- 客户编号
    ,public_agent_name -- 代办人名称
    ,public_agent_cust_id -- 代办人客户编号
    ,public_agent_cert_no -- 代办人证件号码
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_licen_issue_autho_cty_rg_cd -- 代办人发证机关国家和地区代码
    ,public_agent_cert_effect_dt -- 代办人证件生效日期
    ,public_agent_cert_invalid_dt -- 代办人证件失效日期
    ,public_agent_tel_num -- 交易代办人联系电话
    ,agent_reason -- 代办理由
    ,public_agent_rela -- 代办人关系
    ,tran_tm -- 交易时间
    ,agent_vrif_emply_a_id -- 代办核实员工A编号
    ,agent_vrif_emply_b_id -- 代办核实员工B编号
    ,vrif_ps_tel_num -- 被核实人电话号码
    ,vrif_tm -- 核实时间
    ,vrif_rest -- 核实结果
    ,agent_idf_cd -- 代理标识代码
    ,public_agent_flg -- 代办人标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101053'||P1.REFERENCE -- 事件编号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,'9999' -- 法人编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.TRAN_TYPE -- 交易码
    ,P1.EVENT_TYPE -- 代办事件类别编号
    ,P1.TRAN_AMT -- 交易金额
    ,nvl(trim(P1.DOC_TYPE),'-') -- 存款凭证类别代码
    ,P1.VOUCHER_NO -- 业务凭证号码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.COMMISSION_CLIENT_NAME -- 代办人名称
    ,P1.COMMISSION_CLIENT_NO -- 代办人客户编号
    ,P1.COMMISSION_DOCUMENT_ID -- 代办人证件号码
    ,P1.COMMISSION_DOCUMENT_TYPE -- 代办人证件类型代码
    ,nvl(trim(P1.COUNTRY),'XXX') -- 代办人发证机关国家和地区代码
    ,P1.COMMISSION_START_DATE -- 代办人证件生效日期
    ,P1.COMMISSION_EXPIRE_DATE -- 代办人证件失效日期
    ,P1.COMMISSION_CLIENT_TEL -- 交易代办人联系电话
    ,P1.COMMISSION_REASON -- 代办理由
    ,nvl(trim(P1.COMMISSION_RELATION),'-')  -- 代办人关系
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.COMMISSION_CONFIRM_USER_ID_KEY1 -- 代办核实员工A编号
    ,P1.COMMISSION_CONFIRM_USER_ID_KEY2 -- 代办核实员工B编号
    ,P1.COMMISSION_CONFIRM_TEL -- 被核实人电话号码
    ,to_timestamp(trim(P1.COMMISSION_CONFIRM_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 核实时间
    ,P1.COMMISSION_CONFIRM_RESULT -- 核实结果
    ,nvl(trim(P1.COMMISSION_FLAG),'-') -- 代理标识代码
    ,P1.IS_COMMISSION -- 代办人标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_commission_register' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_commission_register p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where  1 = 1 
    and p1.tran_date = to_date('${batch_date}','yyyymmdd') 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_public_agent_rgst_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_public_agent_rgst_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_public_agent_rgst_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_public_agent_rgst_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_public_agent_rgst_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_public_agent_rgst_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);