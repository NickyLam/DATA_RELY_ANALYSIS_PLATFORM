/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lon_post_tran_appl_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_lon_post_tran_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_tran_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,rela_tran_flow_num -- 关联交易流水号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,realtm_tran_flg -- 实时交易标志
    ,rolbk_flow_num -- 回退流水号
    ,core_tran_ref_no -- 核心交易参考号
    ,core_entry_flow_num -- 核心记账流水号
    ,ova_flow_num -- 全局流水号
    ,fft_tran_type_cd -- 福费廷转让类型代码
    ,grace_int_flg -- 宽限利息标志
    ,grace_pric_flg -- 宽限本金标志
    ,adv_repay_rs_cd -- 提前还款原因代码
    ,adv_repay_comnt -- 提前还款说明
    ,adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,regroup_loan_flg -- 重组贷款标志
    ,rela_obj_name -- 关联对象名称
    ,obj_id -- 对象编号
    ,doc_type_name -- 单据类型名称
    ,doc_flow_num -- 单据流水号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,remark -- 备注
    ,other_comnt -- 其他说明
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_tran_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_tran_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_tran_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_acct_transaction-1
insert into ${iml_schema}.agt_lon_post_tran_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,rela_tran_flow_num -- 关联交易流水号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,realtm_tran_flg -- 实时交易标志
    ,rolbk_flow_num -- 回退流水号
    ,core_tran_ref_no -- 核心交易参考号
    ,core_entry_flow_num -- 核心记账流水号
    ,ova_flow_num -- 全局流水号
    ,fft_tran_type_cd -- 福费廷转让类型代码
    ,grace_int_flg -- 宽限利息标志
    ,grace_pric_flg -- 宽限本金标志
    ,adv_repay_rs_cd -- 提前还款原因代码
    ,adv_repay_comnt -- 提前还款说明
    ,adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,regroup_loan_flg -- 重组贷款标志
    ,rela_obj_name -- 关联对象名称
    ,obj_id -- 对象编号
    ,doc_type_name -- 单据类型名称
    ,doc_flow_num -- 单据流水号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,remark -- 备注
    ,other_comnt -- 其他说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206013'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 交易流水号
    ,P1.PARENTTRANSSERIALNO -- 关联交易流水号
    ,nvl(trim(P1.TRANSCODE),'-') -- 交易代码
    ,${iml_schema}.dateformat_max2(P1.TRANSDATE) -- 交易日期
    ,P1.TRANSSUM -- 交易金额
    ,nvl(trim(P1.TRANSSTATUS),'-') -- 交易状态代码
    ,decode(P1.TRANSOCCURTYPE,'01','1','02','0',' ','-',P1.TRANSOCCURTYPE) -- 实时交易标志
    ,P1.FALLBACKTRANSSERIALNO -- 回退流水号
    ,P1.TELLERSERIALNO -- 核心交易参考号
    ,P1.ACCOUNTINGSERIALNO -- 核心记账流水号
    ,P1.CNSMRSRLNO -- 全局流水号
    ,nvl(trim(P1.TRANSTYPE),'-') -- 福费廷转让类型代码
    ,decode(P1.GRACEINTERESTFLAG,'Y','1','N','0',' ','-',P1.GRACEINTERESTFLAG) -- 宽限利息标志
    ,decode(P1.GRACEPRINCIPALFLAG,'Y','1','N','0',' ','-',P1.GRACEPRINCIPALFLAG) -- 宽限本金标志
    ,nvl(trim(P1.REPAYREASONTYPE),'05') -- 提前还款原因代码
    ,P1.REPAYREASON -- 提前还款说明
    ,P1.REPAYSOURCE -- 提前还款资金来源说明
    ,nvl(trim(P1.WHETHERTORESTRUCTURETHELOAN),'-') -- 重组贷款标志
    ,P1.RELATIVEOBJECTTYPE -- 关联对象名称
    ,P1.RELATIVEOBJECTNO -- 对象编号
    ,P1.DOCUMENTTYPE -- 单据类型名称
    ,P1.DOCUMENTNO -- 单据流水号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.REMARK -- 备注
    ,P1.LOG -- 其他说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_acct_transaction' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_acct_transaction p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lon_post_tran_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,rela_tran_flow_num -- 关联交易流水号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,realtm_tran_flg -- 实时交易标志
    ,rolbk_flow_num -- 回退流水号
    ,core_tran_ref_no -- 核心交易参考号
    ,core_entry_flow_num -- 核心记账流水号
    ,ova_flow_num -- 全局流水号
    ,fft_tran_type_cd -- 福费廷转让类型代码
    ,grace_int_flg -- 宽限利息标志
    ,grace_pric_flg -- 宽限本金标志
    ,adv_repay_rs_cd -- 提前还款原因代码
    ,adv_repay_comnt -- 提前还款说明
    ,adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,regroup_loan_flg -- 重组贷款标志
    ,rela_obj_name -- 关联对象名称
    ,obj_id -- 对象编号
    ,doc_type_name -- 单据类型名称
    ,doc_flow_num -- 单据流水号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,remark -- 备注
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,rela_tran_flow_num -- 关联交易流水号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,realtm_tran_flg -- 实时交易标志
    ,rolbk_flow_num -- 回退流水号
    ,core_tran_ref_no -- 核心交易参考号
    ,core_entry_flow_num -- 核心记账流水号
    ,ova_flow_num -- 全局流水号
    ,fft_tran_type_cd -- 福费廷转让类型代码
    ,grace_int_flg -- 宽限利息标志
    ,grace_pric_flg -- 宽限本金标志
    ,adv_repay_rs_cd -- 提前还款原因代码
    ,adv_repay_comnt -- 提前还款说明
    ,adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,regroup_loan_flg -- 重组贷款标志
    ,rela_obj_name -- 关联对象名称
    ,obj_id -- 对象编号
    ,doc_type_name -- 单据类型名称
    ,doc_flow_num -- 单据流水号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,remark -- 备注
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.rela_tran_flow_num, o.rela_tran_flow_num) as rela_tran_flow_num -- 关联交易流水号
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.realtm_tran_flg, o.realtm_tran_flg) as realtm_tran_flg -- 实时交易标志
    ,nvl(n.rolbk_flow_num, o.rolbk_flow_num) as rolbk_flow_num -- 回退流水号
    ,nvl(n.core_tran_ref_no, o.core_tran_ref_no) as core_tran_ref_no -- 核心交易参考号
    ,nvl(n.core_entry_flow_num, o.core_entry_flow_num) as core_entry_flow_num -- 核心记账流水号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.fft_tran_type_cd, o.fft_tran_type_cd) as fft_tran_type_cd -- 福费廷转让类型代码
    ,nvl(n.grace_int_flg, o.grace_int_flg) as grace_int_flg -- 宽限利息标志
    ,nvl(n.grace_pric_flg, o.grace_pric_flg) as grace_pric_flg -- 宽限本金标志
    ,nvl(n.adv_repay_rs_cd, o.adv_repay_rs_cd) as adv_repay_rs_cd -- 提前还款原因代码
    ,nvl(n.adv_repay_comnt, o.adv_repay_comnt) as adv_repay_comnt -- 提前还款说明
    ,nvl(n.adv_repay_cap_src_comnt, o.adv_repay_cap_src_comnt) as adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,nvl(n.regroup_loan_flg, o.regroup_loan_flg) as regroup_loan_flg -- 重组贷款标志
    ,nvl(n.rela_obj_name, o.rela_obj_name) as rela_obj_name -- 关联对象名称
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.doc_type_name, o.doc_type_name) as doc_type_name -- 单据类型名称
    ,nvl(n.doc_flow_num, o.doc_flow_num) as doc_flow_num -- 单据流水号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_tran_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lon_post_tran_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.rela_tran_flow_num <> n.rela_tran_flow_num
        or o.tran_cd <> n.tran_cd
        or o.tran_dt <> n.tran_dt
        or o.tran_amt <> n.tran_amt
        or o.tran_status_cd <> n.tran_status_cd
        or o.realtm_tran_flg <> n.realtm_tran_flg
        or o.rolbk_flow_num <> n.rolbk_flow_num
        or o.core_tran_ref_no <> n.core_tran_ref_no
        or o.core_entry_flow_num <> n.core_entry_flow_num
        or o.ova_flow_num <> n.ova_flow_num
        or o.fft_tran_type_cd <> n.fft_tran_type_cd
        or o.grace_int_flg <> n.grace_int_flg
        or o.grace_pric_flg <> n.grace_pric_flg
        or o.adv_repay_rs_cd <> n.adv_repay_rs_cd
        or o.adv_repay_comnt <> n.adv_repay_comnt
        or o.adv_repay_cap_src_comnt <> n.adv_repay_cap_src_comnt
        or o.regroup_loan_flg <> n.regroup_loan_flg
        or o.rela_obj_name <> n.rela_obj_name
        or o.obj_id <> n.obj_id
        or o.doc_type_name <> n.doc_type_name
        or o.doc_flow_num <> n.doc_flow_num
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.remark <> n.remark
        or o.other_comnt <> n.other_comnt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,rela_tran_flow_num -- 关联交易流水号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,realtm_tran_flg -- 实时交易标志
    ,rolbk_flow_num -- 回退流水号
    ,core_tran_ref_no -- 核心交易参考号
    ,core_entry_flow_num -- 核心记账流水号
    ,ova_flow_num -- 全局流水号
    ,fft_tran_type_cd -- 福费廷转让类型代码
    ,grace_int_flg -- 宽限利息标志
    ,grace_pric_flg -- 宽限本金标志
    ,adv_repay_rs_cd -- 提前还款原因代码
    ,adv_repay_comnt -- 提前还款说明
    ,adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,regroup_loan_flg -- 重组贷款标志
    ,rela_obj_name -- 关联对象名称
    ,obj_id -- 对象编号
    ,doc_type_name -- 单据类型名称
    ,doc_flow_num -- 单据流水号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,remark -- 备注
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,rela_tran_flow_num -- 关联交易流水号
    ,tran_cd -- 交易代码
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,realtm_tran_flg -- 实时交易标志
    ,rolbk_flow_num -- 回退流水号
    ,core_tran_ref_no -- 核心交易参考号
    ,core_entry_flow_num -- 核心记账流水号
    ,ova_flow_num -- 全局流水号
    ,fft_tran_type_cd -- 福费廷转让类型代码
    ,grace_int_flg -- 宽限利息标志
    ,grace_pric_flg -- 宽限本金标志
    ,adv_repay_rs_cd -- 提前还款原因代码
    ,adv_repay_comnt -- 提前还款说明
    ,adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,regroup_loan_flg -- 重组贷款标志
    ,rela_obj_name -- 关联对象名称
    ,obj_id -- 对象编号
    ,doc_type_name -- 单据类型名称
    ,doc_flow_num -- 单据流水号
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,remark -- 备注
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.tran_flow_num -- 交易流水号
    ,o.rela_tran_flow_num -- 关联交易流水号
    ,o.tran_cd -- 交易代码
    ,o.tran_dt -- 交易日期
    ,o.tran_amt -- 交易金额
    ,o.tran_status_cd -- 交易状态代码
    ,o.realtm_tran_flg -- 实时交易标志
    ,o.rolbk_flow_num -- 回退流水号
    ,o.core_tran_ref_no -- 核心交易参考号
    ,o.core_entry_flow_num -- 核心记账流水号
    ,o.ova_flow_num -- 全局流水号
    ,o.fft_tran_type_cd -- 福费廷转让类型代码
    ,o.grace_int_flg -- 宽限利息标志
    ,o.grace_pric_flg -- 宽限本金标志
    ,o.adv_repay_rs_cd -- 提前还款原因代码
    ,o.adv_repay_comnt -- 提前还款说明
    ,o.adv_repay_cap_src_comnt -- 提前还款资金来源说明
    ,o.regroup_loan_flg -- 重组贷款标志
    ,o.rela_obj_name -- 关联对象名称
    ,o.obj_id -- 对象编号
    ,o.doc_type_name -- 单据类型名称
    ,o.doc_flow_num -- 单据流水号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.remark -- 备注
    ,o.other_comnt -- 其他说明
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_tran_appl_icmsf1_bk o
    left join ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lon_post_tran_appl;
--alter table ${iml_schema}.agt_lon_post_tran_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lon_post_tran_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lon_post_tran_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lon_post_tran_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lon_post_tran_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl;
alter table ${iml_schema}.agt_lon_post_tran_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lon_post_tran_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lon_post_tran_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lon_post_tran_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
