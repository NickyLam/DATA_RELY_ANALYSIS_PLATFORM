/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_sign_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_sign_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_sign_agt_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_org_id -- 签约机构编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,agt_layered_flg -- 协议分层标志
    ,agt_key_type_cd -- 协议键类型代码
    ,agt_key -- 协议键值
    ,agt_amt -- 协议金额
    ,sign_main_prod_id -- 签约主产品编号
    ,sign_chn_id -- 签约渠道编号
    ,tran_org_id -- 交易机构编号
    ,agt_sign_dt -- 协议签约日期
    ,sign_teller_id -- 签约柜员编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,allow_clos_acct_flg -- 允许销户标志
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_abbr -- 客户简称
    ,sign_cntpty_acct_id -- 签约对手账户编号
    ,rels_org_id -- 解约机构编号
    ,rels_chn_id -- 解约渠道编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,tran_sign_dt -- 交易签约日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,auto_scd_sign_flg -- 自动续签标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_sign_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_sign_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_sign_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement-1
insert into ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_org_id -- 签约机构编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,agt_layered_flg -- 协议分层标志
    ,agt_key_type_cd -- 协议键类型代码
    ,agt_key -- 协议键值
    ,agt_amt -- 协议金额
    ,sign_main_prod_id -- 签约主产品编号
    ,sign_chn_id -- 签约渠道编号
    ,tran_org_id -- 交易机构编号
    ,agt_sign_dt -- 协议签约日期
    ,sign_teller_id -- 签约柜员编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,allow_clos_acct_flg -- 允许销户标志
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_abbr -- 客户简称
    ,sign_cntpty_acct_id -- 签约对手账户编号
    ,rels_org_id -- 解约机构编号
    ,rels_chn_id -- 解约渠道编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,tran_sign_dt -- 交易签约日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,auto_scd_sign_flg -- 自动续签标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 签约协议编号
    ,P1.SIGN_BRANCH -- 签约机构编号
    ,P1.AGREEMENT_TYPE -- 签约协议类型代码
    ,DECODE(P1.AGREEMENT_CLASS,'','-','LAYER','1','DEFAULT','0',P1.AGREEMENT_CLASS) -- 协议分层标志
    ,NVL(TRIM(P1.AGREEMENT_KEY_TYPE),0) -- 协议键类型代码
    ,NVL(TRIM(P1.AGREEMENT_KEY),0) -- 协议键值
    ,P1.AGREEMENT_AMT -- 协议金额
    ,P1.AGRE_PROD_TYPE -- 签约主产品编号
    ,nvl(trim(P1.SIGN_CHANNEL),'-') -- 签约渠道编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.AGREEMENT_OPEN_DATE -- 协议签约日期
    ,P1.SIGN_USER_ID -- 签约柜员编号
    ,P1.START_DATE -- 有效日期
    ,P1.END_DATE -- 失效日期
    ,P1.AGREEMENT_STATUS -- 签约协议状态代码
    ,decode(trim(p1.AGREEMENT_CLOSE_ACCT_FLAG),'','-','Y','1','N','0',p1.AGREEMENT_CLOSE_ACCT_FLAG) -- 允许销户标志
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 账户产品编号
    ,nvl(trim(P1.ACCT_CCY),'0000') -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_SHORT -- 客户简称
    ,P1.OPPOSITE_INTERNAL_KEY -- 签约对手账户编号
    ,P1.OUT_SIGN_BRANCH -- 解约机构编号
    ,nvl(trim(P1.OUT_SIGN_CHANNEL),'-') -- 解约渠道编号
    ,P1.OUT_SIGN_DATE -- 解约日期
    ,P1.OUT_SIGN_USER_ID -- 解约柜员编号
    ,P1.SIGN_DATE -- 交易签约日期
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,decode(P1.IS_AUTO_SIGN,'Y','1','N','0',' ','-',P1.IS_AUTO_SIGN) -- 自动续签标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement p1
  left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 
    on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO 
   and p8.BASE_ACCT_NO LIKE '0%'
  where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,sign_agt_id
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
        into ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_org_id -- 签约机构编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,agt_layered_flg -- 协议分层标志
    ,agt_key_type_cd -- 协议键类型代码
    ,agt_key -- 协议键值
    ,agt_amt -- 协议金额
    ,sign_main_prod_id -- 签约主产品编号
    ,sign_chn_id -- 签约渠道编号
    ,tran_org_id -- 交易机构编号
    ,agt_sign_dt -- 协议签约日期
    ,sign_teller_id -- 签约柜员编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,allow_clos_acct_flg -- 允许销户标志
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_abbr -- 客户简称
    ,sign_cntpty_acct_id -- 签约对手账户编号
    ,rels_org_id -- 解约机构编号
    ,rels_chn_id -- 解约渠道编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,tran_sign_dt -- 交易签约日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,auto_scd_sign_flg -- 自动续签标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_org_id -- 签约机构编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,agt_layered_flg -- 协议分层标志
    ,agt_key_type_cd -- 协议键类型代码
    ,agt_key -- 协议键值
    ,agt_amt -- 协议金额
    ,sign_main_prod_id -- 签约主产品编号
    ,sign_chn_id -- 签约渠道编号
    ,tran_org_id -- 交易机构编号
    ,agt_sign_dt -- 协议签约日期
    ,sign_teller_id -- 签约柜员编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,allow_clos_acct_flg -- 允许销户标志
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_abbr -- 客户简称
    ,sign_cntpty_acct_id -- 签约对手账户编号
    ,rels_org_id -- 解约机构编号
    ,rels_chn_id -- 解约渠道编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,tran_sign_dt -- 交易签约日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,auto_scd_sign_flg -- 自动续签标志
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
    ,nvl(n.sign_agt_id, o.sign_agt_id) as sign_agt_id -- 签约协议编号
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.sign_agt_type_cd, o.sign_agt_type_cd) as sign_agt_type_cd -- 签约协议类型代码
    ,nvl(n.agt_layered_flg, o.agt_layered_flg) as agt_layered_flg -- 协议分层标志
    ,nvl(n.agt_key_type_cd, o.agt_key_type_cd) as agt_key_type_cd -- 协议键类型代码
    ,nvl(n.agt_key, o.agt_key) as agt_key -- 协议键值
    ,nvl(n.agt_amt, o.agt_amt) as agt_amt -- 协议金额
    ,nvl(n.sign_main_prod_id, o.sign_main_prod_id) as sign_main_prod_id -- 签约主产品编号
    ,nvl(n.sign_chn_id, o.sign_chn_id) as sign_chn_id -- 签约渠道编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.agt_sign_dt, o.agt_sign_dt) as agt_sign_dt -- 协议签约日期
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.valid_dt, o.valid_dt) as valid_dt -- 有效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.allow_clos_acct_flg, o.allow_clos_acct_flg) as allow_clos_acct_flg -- 允许销户标志
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.acct_prod_id, o.acct_prod_id) as acct_prod_id -- 账户产品编号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_abbr, o.cust_abbr) as cust_abbr -- 客户简称
    ,nvl(n.sign_cntpty_acct_id, o.sign_cntpty_acct_id) as sign_cntpty_acct_id -- 签约对手账户编号
    ,nvl(n.rels_org_id, o.rels_org_id) as rels_org_id -- 解约机构编号
    ,nvl(n.rels_chn_id, o.rels_chn_id) as rels_chn_id -- 解约渠道编号
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.rels_teller_id, o.rels_teller_id) as rels_teller_id -- 解约柜员编号
    ,nvl(n.tran_sign_dt, o.tran_sign_dt) as tran_sign_dt -- 交易签约日期
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.auto_scd_sign_flg, o.auto_scd_sign_flg) as auto_scd_sign_flg -- 自动续签标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.sign_agt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.sign_agt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.sign_agt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.sign_agt_id = n.sign_agt_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.sign_agt_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.sign_agt_id is null
    )
    or (
        o.sign_org_id <> n.sign_org_id
        or o.sign_agt_type_cd <> n.sign_agt_type_cd
        or o.agt_layered_flg <> n.agt_layered_flg
        or o.agt_key_type_cd <> n.agt_key_type_cd
        or o.agt_key <> n.agt_key
        or o.agt_amt <> n.agt_amt
        or o.sign_main_prod_id <> n.sign_main_prod_id
        or o.sign_chn_id <> n.sign_chn_id
        or o.tran_org_id <> n.tran_org_id
        or o.agt_sign_dt <> n.agt_sign_dt
        or o.sign_teller_id <> n.sign_teller_id
        or o.valid_dt <> n.valid_dt
        or o.invalid_dt <> n.invalid_dt
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.allow_clos_acct_flg <> n.allow_clos_acct_flg
        or o.cust_acct_num <> n.cust_acct_num
        or o.acct_prod_id <> n.acct_prod_id
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_name <> n.acct_name
        or o.cust_id <> n.cust_id
        or o.cust_abbr <> n.cust_abbr
        or o.sign_cntpty_acct_id <> n.sign_cntpty_acct_id
        or o.rels_org_id <> n.rels_org_id
        or o.rels_chn_id <> n.rels_chn_id
        or o.rels_dt <> n.rels_dt
        or o.rels_teller_id <> n.rels_teller_id
        or o.tran_sign_dt <> n.tran_sign_dt
        or o.tran_teller_id <> n.tran_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.auto_scd_sign_flg <> n.auto_scd_sign_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_org_id -- 签约机构编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,agt_layered_flg -- 协议分层标志
    ,agt_key_type_cd -- 协议键类型代码
    ,agt_key -- 协议键值
    ,agt_amt -- 协议金额
    ,sign_main_prod_id -- 签约主产品编号
    ,sign_chn_id -- 签约渠道编号
    ,tran_org_id -- 交易机构编号
    ,agt_sign_dt -- 协议签约日期
    ,sign_teller_id -- 签约柜员编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,allow_clos_acct_flg -- 允许销户标志
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_abbr -- 客户简称
    ,sign_cntpty_acct_id -- 签约对手账户编号
    ,rels_org_id -- 解约机构编号
    ,rels_chn_id -- 解约渠道编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,tran_sign_dt -- 交易签约日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,auto_scd_sign_flg -- 自动续签标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_agt_id -- 签约协议编号
    ,sign_org_id -- 签约机构编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,agt_layered_flg -- 协议分层标志
    ,agt_key_type_cd -- 协议键类型代码
    ,agt_key -- 协议键值
    ,agt_amt -- 协议金额
    ,sign_main_prod_id -- 签约主产品编号
    ,sign_chn_id -- 签约渠道编号
    ,tran_org_id -- 交易机构编号
    ,agt_sign_dt -- 协议签约日期
    ,sign_teller_id -- 签约柜员编号
    ,valid_dt -- 有效日期
    ,invalid_dt -- 失效日期
    ,sign_agt_status_cd -- 签约协议状态代码
    ,allow_clos_acct_flg -- 允许销户标志
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_abbr -- 客户简称
    ,sign_cntpty_acct_id -- 签约对手账户编号
    ,rels_org_id -- 解约机构编号
    ,rels_chn_id -- 解约渠道编号
    ,rels_dt -- 解约日期
    ,rels_teller_id -- 解约柜员编号
    ,tran_sign_dt -- 交易签约日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,auto_scd_sign_flg -- 自动续签标志
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
    ,o.sign_agt_id -- 签约协议编号
    ,o.sign_org_id -- 签约机构编号
    ,o.sign_agt_type_cd -- 签约协议类型代码
    ,o.agt_layered_flg -- 协议分层标志
    ,o.agt_key_type_cd -- 协议键类型代码
    ,o.agt_key -- 协议键值
    ,o.agt_amt -- 协议金额
    ,o.sign_main_prod_id -- 签约主产品编号
    ,o.sign_chn_id -- 签约渠道编号
    ,o.tran_org_id -- 交易机构编号
    ,o.agt_sign_dt -- 协议签约日期
    ,o.sign_teller_id -- 签约柜员编号
    ,o.valid_dt -- 有效日期
    ,o.invalid_dt -- 失效日期
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.allow_clos_acct_flg -- 允许销户标志
    ,o.cust_acct_num -- 客户账号
    ,o.acct_prod_id -- 账户产品编号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.sub_acct_num -- 子账号
    ,o.acct_name -- 账户名称
    ,o.cust_id -- 客户编号
    ,o.cust_abbr -- 客户简称
    ,o.sign_cntpty_acct_id -- 签约对手账户编号
    ,o.rels_org_id -- 解约机构编号
    ,o.rels_chn_id -- 解约渠道编号
    ,o.rels_dt -- 解约日期
    ,o.rels_teller_id -- 解约柜员编号
    ,o.tran_sign_dt -- 交易签约日期
    ,o.tran_teller_id -- 交易柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.auto_scd_sign_flg -- 自动续签标志
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
from ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.sign_agt_id = n.sign_agt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.sign_agt_id = d.sign_agt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_sign_agt_h;
--alter table ${iml_schema}.agt_dep_sign_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_sign_agt_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_sign_agt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_sign_agt_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_sign_agt_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_sign_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_sign_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_sign_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_sign_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
