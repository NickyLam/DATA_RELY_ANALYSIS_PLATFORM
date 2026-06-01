/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_int_rat_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_int_rat_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_int_rat_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,init_apv_form_id -- 原审批单编号
    ,add_agt_flg_cd -- 新增协议标志代码
    ,sub_acct_num -- 子账号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,int_rat_agt_status_cd -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,new_acct_num_flg -- 新账号标志
    ,int_rat_agt_tenor -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,dep_tenor -- 存款期限
    ,dep_tenor_corp_cd -- 存款期限单位代码
    ,base_rat -- 基准利率
    ,float_ratio -- 浮动比例
    ,exec_int_rat -- 执行利率
    ,rs_descb -- 原因描述
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,hxb_crdt_cust_flg -- 我行授信客户标志
    ,appl_pric_amt_uplmi -- 申请本金金额上限
    ,int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_int_rat_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_int_rat_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_int_rat_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_int_rate_form_msg-1
insert into ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,init_apv_form_id -- 原审批单编号
    ,add_agt_flg_cd -- 新增协议标志代码
    ,sub_acct_num -- 子账号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,int_rat_agt_status_cd -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,new_acct_num_flg -- 新账号标志
    ,int_rat_agt_tenor -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,dep_tenor -- 存款期限
    ,dep_tenor_corp_cd -- 存款期限单位代码
    ,base_rat -- 基准利率
    ,float_ratio -- 浮动比例
    ,exec_int_rat -- 执行利率
    ,rs_descb -- 原因描述
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,hxb_crdt_cust_flg -- 我行授信客户标志
    ,appl_pric_amt_uplmi -- 申请本金金额上限
    ,int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300023'||P1.INT_RATE_FORM_NO||P1.INTERNAL_KEY||P1.BASE_ACCT_NO||P1.ACCT_SEQ_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INT_RATE_FORM_NO -- 利率审批单编号
    ,P1.PRE_INT_RATE_FORM_NO -- 原审批单编号
    ,nvl(trim(P1.ADD_AGREEMENT_FLAG),'-') -- 新增协议标志代码
    ,P1.acct_seq_no -- 子账号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_NAME -- 客户名称
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,nvl(trim(P1.INT_RATE_FORM_APPLY_TYPE),'-') -- 利率审批申请类别代码
    ,nvl(trim(P1.INT_AGREEMENT_STATUS),'-') -- 利率协议状态代码
    ,nvl(trim(P1.INT_RATE_RB_PROD_TYPE),'-') -- 利率审批单存款品种代码
    ,decode(trim(P1.NEW_ACCT_NO_FLAG),'Y','1','N','0','','-',trim(P1.NEW_ACCT_NO_FLAG)) -- 新账号标志
    ,nvl(trim(substr(INT_RATE_TERM,1,1)),'0') -- 利率协议期限
    ,nvl(substr(INT_RATE_TERM,2,1),'-') -- 利率协议期限单位代码
    ,nvl(trim(substr(RB_PROD_TERM,1,1)),'0') -- 存款期限
    ,nvl(substr(RB_PROD_TERM,2,1),'-') -- 存款期限单位代码
    ,P1.DISC_BASE_RATE -- 基准利率
    ,P1.FLOAT_POINT -- 浮动比例
    ,P1.REAL_RATE -- 执行利率
    ,P1.REASON -- 原因描述
    ,P1.VALID_FROM_DATE -- 协议生效日期
    ,P1.VALID_THRU_DATE -- 协议失效日期
    ,decode(trim(P1.AUTH_CLIENT_FLAG),'Y','1','N','0','','-',trim(P1.AUTH_CLIENT_FLAG)) -- 我行授信客户标志
    ,P1.PRI_AMT_LIMIT -- 申请本金金额上限
    ,P1.INT_VALID_FROM_DATE -- 利率优惠生效日期
    ,decode(P1.INT_VALID_THRU_DATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),P1.INT_VALID_THRU_DATE) -- 利率优惠失效日期
    ,decode(P1.LAST_CHANGE_DATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),P1.LAST_CHANGE_DATE) -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_int_rate_form_msg' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_int_rate_form_msg p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,init_apv_form_id -- 原审批单编号
    ,add_agt_flg_cd -- 新增协议标志代码
    ,sub_acct_num -- 子账号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,int_rat_agt_status_cd -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,new_acct_num_flg -- 新账号标志
    ,int_rat_agt_tenor -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,dep_tenor -- 存款期限
    ,dep_tenor_corp_cd -- 存款期限单位代码
    ,base_rat -- 基准利率
    ,float_ratio -- 浮动比例
    ,exec_int_rat -- 执行利率
    ,rs_descb -- 原因描述
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,hxb_crdt_cust_flg -- 我行授信客户标志
    ,appl_pric_amt_uplmi -- 申请本金金额上限
    ,int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,init_apv_form_id -- 原审批单编号
    ,add_agt_flg_cd -- 新增协议标志代码
    ,sub_acct_num -- 子账号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,int_rat_agt_status_cd -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,new_acct_num_flg -- 新账号标志
    ,int_rat_agt_tenor -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,dep_tenor -- 存款期限
    ,dep_tenor_corp_cd -- 存款期限单位代码
    ,base_rat -- 基准利率
    ,float_ratio -- 浮动比例
    ,exec_int_rat -- 执行利率
    ,rs_descb -- 原因描述
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,hxb_crdt_cust_flg -- 我行授信客户标志
    ,appl_pric_amt_uplmi -- 申请本金金额上限
    ,int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.int_rat_apv_form_id, o.int_rat_apv_form_id) as int_rat_apv_form_id -- 利率审批单编号
    ,nvl(n.init_apv_form_id, o.init_apv_form_id) as init_apv_form_id -- 原审批单编号
    ,nvl(n.add_agt_flg_cd, o.add_agt_flg_cd) as add_agt_flg_cd -- 新增协议标志代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_rat_apv_appl_cate_cd, o.int_rat_apv_appl_cate_cd) as int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,nvl(n.int_rat_agt_status_cd, o.int_rat_agt_status_cd) as int_rat_agt_status_cd -- 利率协议状态代码
    ,nvl(n.int_rat_apv_form_dep_breed_cd, o.int_rat_apv_form_dep_breed_cd) as int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,nvl(n.new_acct_num_flg, o.new_acct_num_flg) as new_acct_num_flg -- 新账号标志
    ,nvl(n.int_rat_agt_tenor, o.int_rat_agt_tenor) as int_rat_agt_tenor -- 利率协议期限
    ,nvl(n.int_rat_agt_tenor_corp_cd, o.int_rat_agt_tenor_corp_cd) as int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.dep_tenor_corp_cd, o.dep_tenor_corp_cd) as dep_tenor_corp_cd -- 存款期限单位代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.float_ratio, o.float_ratio) as float_ratio -- 浮动比例
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.rs_descb, o.rs_descb) as rs_descb -- 原因描述
    ,nvl(n.agt_effect_dt, o.agt_effect_dt) as agt_effect_dt -- 协议生效日期
    ,nvl(n.agt_invalid_dt, o.agt_invalid_dt) as agt_invalid_dt -- 协议失效日期
    ,nvl(n.hxb_crdt_cust_flg, o.hxb_crdt_cust_flg) as hxb_crdt_cust_flg -- 我行授信客户标志
    ,nvl(n.appl_pric_amt_uplmi, o.appl_pric_amt_uplmi) as appl_pric_amt_uplmi -- 申请本金金额上限
    ,nvl(n.int_rat_prefr_effect_dt, o.int_rat_prefr_effect_dt) as int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,nvl(n.int_rat_prefr_invalid_dt, o.int_rat_prefr_invalid_dt) as int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.int_rat_apv_form_id <> n.int_rat_apv_form_id
        or o.init_apv_form_id <> n.init_apv_form_id
        or o.add_agt_flg_cd <> n.add_agt_flg_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_id <> n.acct_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.curr_cd <> n.curr_cd
        or o.int_rat_apv_appl_cate_cd <> n.int_rat_apv_appl_cate_cd
        or o.int_rat_agt_status_cd <> n.int_rat_agt_status_cd
        or o.int_rat_apv_form_dep_breed_cd <> n.int_rat_apv_form_dep_breed_cd
        or o.new_acct_num_flg <> n.new_acct_num_flg
        or o.int_rat_agt_tenor <> n.int_rat_agt_tenor
        or o.int_rat_agt_tenor_corp_cd <> n.int_rat_agt_tenor_corp_cd
        or o.dep_tenor <> n.dep_tenor
        or o.dep_tenor_corp_cd <> n.dep_tenor_corp_cd
        or o.base_rat <> n.base_rat
        or o.float_ratio <> n.float_ratio
        or o.exec_int_rat <> n.exec_int_rat
        or o.rs_descb <> n.rs_descb
        or o.agt_effect_dt <> n.agt_effect_dt
        or o.agt_invalid_dt <> n.agt_invalid_dt
        or o.hxb_crdt_cust_flg <> n.hxb_crdt_cust_flg
        or o.appl_pric_amt_uplmi <> n.appl_pric_amt_uplmi
        or o.int_rat_prefr_effect_dt <> n.int_rat_prefr_effect_dt
        or o.int_rat_prefr_invalid_dt <> n.int_rat_prefr_invalid_dt
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,init_apv_form_id -- 原审批单编号
    ,add_agt_flg_cd -- 新增协议标志代码
    ,sub_acct_num -- 子账号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,int_rat_agt_status_cd -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,new_acct_num_flg -- 新账号标志
    ,int_rat_agt_tenor -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,dep_tenor -- 存款期限
    ,dep_tenor_corp_cd -- 存款期限单位代码
    ,base_rat -- 基准利率
    ,float_ratio -- 浮动比例
    ,exec_int_rat -- 执行利率
    ,rs_descb -- 原因描述
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,hxb_crdt_cust_flg -- 我行授信客户标志
    ,appl_pric_amt_uplmi -- 申请本金金额上限
    ,int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,int_rat_apv_form_id -- 利率审批单编号
    ,init_apv_form_id -- 原审批单编号
    ,add_agt_flg_cd -- 新增协议标志代码
    ,sub_acct_num -- 子账号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,curr_cd -- 币种代码
    ,int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,int_rat_agt_status_cd -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,new_acct_num_flg -- 新账号标志
    ,int_rat_agt_tenor -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,dep_tenor -- 存款期限
    ,dep_tenor_corp_cd -- 存款期限单位代码
    ,base_rat -- 基准利率
    ,float_ratio -- 浮动比例
    ,exec_int_rat -- 执行利率
    ,rs_descb -- 原因描述
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,hxb_crdt_cust_flg -- 我行授信客户标志
    ,appl_pric_amt_uplmi -- 申请本金金额上限
    ,int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.int_rat_apv_form_id -- 利率审批单编号
    ,o.init_apv_form_id -- 原审批单编号
    ,o.add_agt_flg_cd -- 新增协议标志代码
    ,o.sub_acct_num -- 子账号
    ,o.acct_id -- 账户编号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.curr_cd -- 币种代码
    ,o.int_rat_apv_appl_cate_cd -- 利率审批申请类别代码
    ,o.int_rat_agt_status_cd -- 利率协议状态代码
    ,o.int_rat_apv_form_dep_breed_cd -- 利率审批单存款品种代码
    ,o.new_acct_num_flg -- 新账号标志
    ,o.int_rat_agt_tenor -- 利率协议期限
    ,o.int_rat_agt_tenor_corp_cd -- 利率协议期限单位代码
    ,o.dep_tenor -- 存款期限
    ,o.dep_tenor_corp_cd -- 存款期限单位代码
    ,o.base_rat -- 基准利率
    ,o.float_ratio -- 浮动比例
    ,o.exec_int_rat -- 执行利率
    ,o.rs_descb -- 原因描述
    ,o.agt_effect_dt -- 协议生效日期
    ,o.agt_invalid_dt -- 协议失效日期
    ,o.hxb_crdt_cust_flg -- 我行授信客户标志
    ,o.appl_pric_amt_uplmi -- 申请本金金额上限
    ,o.int_rat_prefr_effect_dt -- 利率优惠生效日期
    ,o.int_rat_prefr_invalid_dt -- 利率优惠失效日期
    ,o.final_modif_dt -- 最后修改日期
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
from ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_int_rat_info_h;
--alter table ${iml_schema}.agt_dep_int_rat_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_int_rat_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_int_rat_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_dep_int_rat_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_int_rat_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_int_rat_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_int_rat_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_int_rat_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_int_rat_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
