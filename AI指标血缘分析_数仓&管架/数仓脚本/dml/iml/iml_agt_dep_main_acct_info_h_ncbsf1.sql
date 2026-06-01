/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_main_acct_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_main_acct_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_main_acct_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,card_no -- 卡号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_sub_acct_num -- 账户子账号
    ,acct_curr_cd -- 账户币种代码
    ,open_acct_org_id -- 开户机构编号
    ,cust_acct_open_acct_dt -- 客户账户开户日期
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,clos_acct_rs -- 销户原因
    ,clos_acct_teller_id -- 销户柜员编号
    ,acct_lmt_flg -- 账户限制标志
    ,reg_acct_type_cd -- 定期账户类型代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,init_prod_id -- 原产品编号
    ,cust_mgr_id -- 客户经理编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,src_module_type_cd -- 源模块类型代码
    ,cust_type_cd -- 客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,clos_acct_dt -- 销户日期
    ,acct_usage -- 账户用途
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_main_acct_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_main_acct_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_main_acct_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_base_acct-1
insert into ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,card_no -- 卡号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_sub_acct_num -- 账户子账号
    ,acct_curr_cd -- 账户币种代码
    ,open_acct_org_id -- 开户机构编号
    ,cust_acct_open_acct_dt -- 客户账户开户日期
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,clos_acct_rs -- 销户原因
    ,clos_acct_teller_id -- 销户柜员编号
    ,acct_lmt_flg -- 账户限制标志
    ,reg_acct_type_cd -- 定期账户类型代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,init_prod_id -- 原产品编号
    ,cust_mgr_id -- 客户经理编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,src_module_type_cd -- 源模块类型代码
    ,cust_type_cd -- 客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,clos_acct_dt -- 销户日期
    ,acct_usage -- 账户用途
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CARD_NO -- 卡号
    ,nvl(trim(P1.SOURCE_TYPE),'-') -- 开户渠道编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 账户产品编号
    ,P1.ACCT_SEQ_NO -- 账户子账号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.ACCT_OPEN_DATE -- 客户账户开户日期
    ,P1.ACCT_TYPE -- 核心账户类型代码
    ,P1.ACCT_NAME -- 账户名称
    ,NVL(TRIM(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,NVL(trim(P1.ACCT_STATUS_PREV),'-') -- 上一账户状态代码
    ,P1.ACCT_STATUS_UPD_DATE -- 账户状态变更日期
    ,P1.ACCT_CLOSE_REASON -- 销户原因
    ,P1.ACCT_CLOSE_USER_ID -- 销户柜员编号
    ,decode(trim(p1.ACCT_RES_STATUS),'','-','Y','1','N','0',p1.ACCT_RES_STATUS) -- 账户限制标志
    ,nvl(trim(P1.FIXED_CALL),'-') -- 定期账户类型代码
    ,nvl(trim(P1.DOC_TYPE),'-') -- 存款凭证类别代码
    ,P1.VOUCHER_START_NO -- 凭证号码
    ,nvl(trim(P1.VOUCHER_STATUS),'-') -- 凭证状态代码
    ,P1.OLD_PROD_TYPE -- 原产品编号
    ,P1.ACCT_EXEC -- 客户经理编号
    ,decode(trim(p1.ALL_DEP_IND),'','-','Y','1','N','0',p1.ALL_DEP_IND) -- 通存标志
    ,decode(trim(p1.ALL_DRA_IND),'','-','Y','1','N','0',p1.ALL_DRA_IND) -- 通兑标志
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.ACCT_CLOSE_DATE -- 销户日期
    ,P1.REASON_CODE -- 账户用途
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_base_acct' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_base_acct p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_BASE_ACCT'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_DEP_MAIN_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,card_no -- 卡号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_sub_acct_num -- 账户子账号
    ,acct_curr_cd -- 账户币种代码
    ,open_acct_org_id -- 开户机构编号
    ,cust_acct_open_acct_dt -- 客户账户开户日期
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,clos_acct_rs -- 销户原因
    ,clos_acct_teller_id -- 销户柜员编号
    ,acct_lmt_flg -- 账户限制标志
    ,reg_acct_type_cd -- 定期账户类型代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,init_prod_id -- 原产品编号
    ,cust_mgr_id -- 客户经理编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,src_module_type_cd -- 源模块类型代码
    ,cust_type_cd -- 客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,clos_acct_dt -- 销户日期
    ,acct_usage -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,card_no -- 卡号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_sub_acct_num -- 账户子账号
    ,acct_curr_cd -- 账户币种代码
    ,open_acct_org_id -- 开户机构编号
    ,cust_acct_open_acct_dt -- 客户账户开户日期
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,clos_acct_rs -- 销户原因
    ,clos_acct_teller_id -- 销户柜员编号
    ,acct_lmt_flg -- 账户限制标志
    ,reg_acct_type_cd -- 定期账户类型代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,init_prod_id -- 原产品编号
    ,cust_mgr_id -- 客户经理编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,src_module_type_cd -- 源模块类型代码
    ,cust_type_cd -- 客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,clos_acct_dt -- 销户日期
    ,acct_usage -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.open_acct_chn_id, o.open_acct_chn_id) as open_acct_chn_id -- 开户渠道编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.acct_prod_id, o.acct_prod_id) as acct_prod_id -- 账户产品编号
    ,nvl(n.acct_sub_acct_num, o.acct_sub_acct_num) as acct_sub_acct_num -- 账户子账号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.cust_acct_open_acct_dt, o.cust_acct_open_acct_dt) as cust_acct_open_acct_dt -- 客户账户开户日期
    ,nvl(n.core_acct_type_cd, o.core_acct_type_cd) as core_acct_type_cd -- 核心账户类型代码
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.last_acct_status_cd, o.last_acct_status_cd) as last_acct_status_cd -- 上一账户状态代码
    ,nvl(n.acct_status_modif_dt, o.acct_status_modif_dt) as acct_status_modif_dt -- 账户状态变更日期
    ,nvl(n.clos_acct_rs, o.clos_acct_rs) as clos_acct_rs -- 销户原因
    ,nvl(n.clos_acct_teller_id, o.clos_acct_teller_id) as clos_acct_teller_id -- 销户柜员编号
    ,nvl(n.acct_lmt_flg, o.acct_lmt_flg) as acct_lmt_flg -- 账户限制标志
    ,nvl(n.reg_acct_type_cd, o.reg_acct_type_cd) as reg_acct_type_cd -- 定期账户类型代码
    ,nvl(n.dep_vouch_cate_cd, o.dep_vouch_cate_cd) as dep_vouch_cate_cd -- 存款凭证类别代码
    ,nvl(n.vouch_no, o.vouch_no) as vouch_no -- 凭证号码
    ,nvl(n.vouch_status_cd, o.vouch_status_cd) as vouch_status_cd -- 凭证状态代码
    ,nvl(n.init_prod_id, o.init_prod_id) as init_prod_id -- 原产品编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.general_storage_flg, o.general_storage_flg) as general_storage_flg -- 通存标志
    ,nvl(n.general_exch_flg, o.general_exch_flg) as general_exch_flg -- 通兑标志
    ,nvl(n.src_module_type_cd, o.src_module_type_cd) as src_module_type_cd -- 源模块类型代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.acct_usage, o.acct_usage) as acct_usage -- 账户用途
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.acct_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.acct_id is null
        and n.lp_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.card_no <> n.card_no
        or o.open_acct_chn_id <> n.open_acct_chn_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.acct_prod_id <> n.acct_prod_id
        or o.acct_sub_acct_num <> n.acct_sub_acct_num
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.cust_acct_open_acct_dt <> n.cust_acct_open_acct_dt
        or o.core_acct_type_cd <> n.core_acct_type_cd
        or o.acct_name <> n.acct_name
        or o.acct_status_cd <> n.acct_status_cd
        or o.last_acct_status_cd <> n.last_acct_status_cd
        or o.acct_status_modif_dt <> n.acct_status_modif_dt
        or o.clos_acct_rs <> n.clos_acct_rs
        or o.clos_acct_teller_id <> n.clos_acct_teller_id
        or o.acct_lmt_flg <> n.acct_lmt_flg
        or o.reg_acct_type_cd <> n.reg_acct_type_cd
        or o.dep_vouch_cate_cd <> n.dep_vouch_cate_cd
        or o.vouch_no <> n.vouch_no
        or o.vouch_status_cd <> n.vouch_status_cd
        or o.init_prod_id <> n.init_prod_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.general_storage_flg <> n.general_storage_flg
        or o.general_exch_flg <> n.general_exch_flg
        or o.src_module_type_cd <> n.src_module_type_cd
        or o.cust_type_cd <> n.cust_type_cd
        or o.tran_teller_id <> n.tran_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.clos_acct_dt <> n.clos_acct_dt
        or o.acct_usage <> n.acct_usage
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,card_no -- 卡号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_sub_acct_num -- 账户子账号
    ,acct_curr_cd -- 账户币种代码
    ,open_acct_org_id -- 开户机构编号
    ,cust_acct_open_acct_dt -- 客户账户开户日期
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,clos_acct_rs -- 销户原因
    ,clos_acct_teller_id -- 销户柜员编号
    ,acct_lmt_flg -- 账户限制标志
    ,reg_acct_type_cd -- 定期账户类型代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,init_prod_id -- 原产品编号
    ,cust_mgr_id -- 客户经理编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,src_module_type_cd -- 源模块类型代码
    ,cust_type_cd -- 客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,clos_acct_dt -- 销户日期
    ,acct_usage -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,card_no -- 卡号
    ,open_acct_chn_id -- 开户渠道编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_sub_acct_num -- 账户子账号
    ,acct_curr_cd -- 账户币种代码
    ,open_acct_org_id -- 开户机构编号
    ,cust_acct_open_acct_dt -- 客户账户开户日期
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,clos_acct_rs -- 销户原因
    ,clos_acct_teller_id -- 销户柜员编号
    ,acct_lmt_flg -- 账户限制标志
    ,reg_acct_type_cd -- 定期账户类型代码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_no -- 凭证号码
    ,vouch_status_cd -- 凭证状态代码
    ,init_prod_id -- 原产品编号
    ,cust_mgr_id -- 客户经理编号
    ,general_storage_flg -- 通存标志
    ,general_exch_flg -- 通兑标志
    ,src_module_type_cd -- 源模块类型代码
    ,cust_type_cd -- 客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,final_modif_teller_id -- 最后修改柜员编号
    ,clos_acct_dt -- 销户日期
    ,acct_usage -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.acct_id -- 账户编号
    ,o.lp_id -- 法人编号
    ,o.cust_id -- 客户编号
    ,o.card_no -- 卡号
    ,o.open_acct_chn_id -- 开户渠道编号
    ,o.cust_acct_num -- 客户账号
    ,o.acct_prod_id -- 账户产品编号
    ,o.acct_sub_acct_num -- 账户子账号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.open_acct_org_id -- 开户机构编号
    ,o.cust_acct_open_acct_dt -- 客户账户开户日期
    ,o.core_acct_type_cd -- 核心账户类型代码
    ,o.acct_name -- 账户名称
    ,o.acct_status_cd -- 账户状态代码
    ,o.last_acct_status_cd -- 上一账户状态代码
    ,o.acct_status_modif_dt -- 账户状态变更日期
    ,o.clos_acct_rs -- 销户原因
    ,o.clos_acct_teller_id -- 销户柜员编号
    ,o.acct_lmt_flg -- 账户限制标志
    ,o.reg_acct_type_cd -- 定期账户类型代码
    ,o.dep_vouch_cate_cd -- 存款凭证类别代码
    ,o.vouch_no -- 凭证号码
    ,o.vouch_status_cd -- 凭证状态代码
    ,o.init_prod_id -- 原产品编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.general_storage_flg -- 通存标志
    ,o.general_exch_flg -- 通兑标志
    ,o.src_module_type_cd -- 源模块类型代码
    ,o.cust_type_cd -- 客户类型代码
    ,o.tran_teller_id -- 交易柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.clos_acct_dt -- 销户日期
    ,o.acct_usage -- 账户用途
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
from ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.acct_id = d.acct_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_main_acct_info_h;
--alter table ${iml_schema}.agt_dep_main_acct_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_main_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_main_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_dep_main_acct_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_main_acct_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_main_acct_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_main_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_main_acct_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_main_acct_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
