/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_payfan_mercht_sign_info_h_mrmsf1
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
alter table ${iml_schema}.agt_payfan_mercht_sign_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_mercht_sign_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_abbr -- 商户简称
    ,white_list_ctrl_flg -- 白名单控制标志
    ,mercht_status_cd -- 商户状态代码
    ,supv_acct_id -- 监管账户编号
    ,supv_acct_name -- 监管账户名称
    ,supv_acct_open_bank_num -- 监管账户开户行号
    ,supv_acct_open_bank_name -- 监管账户开户行名称
    ,supv_acct_type_cd -- 监管账户类型代码
    ,belong_org_id -- 所属机构编号
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,adv_acct_open_bank_num -- 垫资账户开户行号
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,flow_status_cd -- 流程状态代码
    ,free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,matn_teller_id -- 维护柜员编号
    ,apv_teller_id -- 审批柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_payfan_mercht_sign_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_mercht_sign_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_mercht_sign_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_edu_merch-1
insert into ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_abbr -- 商户简称
    ,white_list_ctrl_flg -- 白名单控制标志
    ,mercht_status_cd -- 商户状态代码
    ,supv_acct_id -- 监管账户编号
    ,supv_acct_name -- 监管账户名称
    ,supv_acct_open_bank_num -- 监管账户开户行号
    ,supv_acct_open_bank_name -- 监管账户开户行名称
    ,supv_acct_type_cd -- 监管账户类型代码
    ,belong_org_id -- 所属机构编号
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,adv_acct_open_bank_num -- 垫资账户开户行号
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,flow_status_cd -- 流程状态代码
    ,free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,matn_teller_id -- 维护柜员编号
    ,apv_teller_id -- 审批柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300042'||P1.MERCH_NUM -- 协议编号
    ,'9999' -- 法人编号
    ,P1.MERCH_NUM -- 商户编号
    ,P1.MERCH_NAME -- 商户名称
    ,P1.SPELL_NAME -- 商户简称
    ,nvl(trim(P1.IS_W_CONTROL),'-') -- 白名单控制标志
    ,nvl(trim(P1.MERCH_STATUS),'-') -- 商户状态代码
    ,P1.JG_ACCT_NO -- 监管账户编号
    ,P1.JG_ACCT_NAME -- 监管账户名称
    ,P1.JG_ACCT_BANK_NO -- 监管账户开户行号
    ,P1.JG_ACCT_BANK_NAME -- 监管账户开户行名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.JG_ACCT_TYPE END -- 监管账户类型代码
    ,P1.BRH_ID -- 所属机构编号
    ,P1.DZ_ACCT_NO -- 垫资账户编号
    ,P1.DZ_ACCT_NAME -- 垫资账户名称
    ,P1.DZ_ACCT_BANK_NO -- 垫资账户开户行号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DZ_ACCT_TYPE END -- 垫资账户类型代码
    ,nvl(trim(P1.FLOW_STATUS),'-') -- 流程状态代码
    ,nvl(trim(P1.IS_APPROVE),'-') -- 免审批可转账标志
    ,${iml_schema}.timeformat_min(P1.CREATED_TIME) -- 创建时间
    ,${iml_schema}.timeformat_max2(P1.UPDATED_TIME) -- 修改时间
    ,P1.CHECK_TLR -- 维护柜员编号
    ,P1.ACQ_INST_ID -- 审批柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_edu_merch' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_edu_merch p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.JG_ACCT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_EDU_MERCH'
        AND R1.SRC_FIELD_EN_NAME= 'JG_ACCT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_MERCHT_SIGN_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'SUPV_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DZ_ACCT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_EDU_MERCH'
        AND R2.SRC_FIELD_EN_NAME= 'DZ_ACCT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_MERCHT_SIGN_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ADV_ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_tm 
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
        into ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_abbr -- 商户简称
    ,white_list_ctrl_flg -- 白名单控制标志
    ,mercht_status_cd -- 商户状态代码
    ,supv_acct_id -- 监管账户编号
    ,supv_acct_name -- 监管账户名称
    ,supv_acct_open_bank_num -- 监管账户开户行号
    ,supv_acct_open_bank_name -- 监管账户开户行名称
    ,supv_acct_type_cd -- 监管账户类型代码
    ,belong_org_id -- 所属机构编号
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,adv_acct_open_bank_num -- 垫资账户开户行号
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,flow_status_cd -- 流程状态代码
    ,free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,matn_teller_id -- 维护柜员编号
    ,apv_teller_id -- 审批柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_abbr -- 商户简称
    ,white_list_ctrl_flg -- 白名单控制标志
    ,mercht_status_cd -- 商户状态代码
    ,supv_acct_id -- 监管账户编号
    ,supv_acct_name -- 监管账户名称
    ,supv_acct_open_bank_num -- 监管账户开户行号
    ,supv_acct_open_bank_name -- 监管账户开户行名称
    ,supv_acct_type_cd -- 监管账户类型代码
    ,belong_org_id -- 所属机构编号
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,adv_acct_open_bank_num -- 垫资账户开户行号
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,flow_status_cd -- 流程状态代码
    ,free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,matn_teller_id -- 维护柜员编号
    ,apv_teller_id -- 审批柜员编号
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
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.mercht_name, o.mercht_name) as mercht_name -- 商户名称
    ,nvl(n.mercht_abbr, o.mercht_abbr) as mercht_abbr -- 商户简称
    ,nvl(n.white_list_ctrl_flg, o.white_list_ctrl_flg) as white_list_ctrl_flg -- 白名单控制标志
    ,nvl(n.mercht_status_cd, o.mercht_status_cd) as mercht_status_cd -- 商户状态代码
    ,nvl(n.supv_acct_id, o.supv_acct_id) as supv_acct_id -- 监管账户编号
    ,nvl(n.supv_acct_name, o.supv_acct_name) as supv_acct_name -- 监管账户名称
    ,nvl(n.supv_acct_open_bank_num, o.supv_acct_open_bank_num) as supv_acct_open_bank_num -- 监管账户开户行号
    ,nvl(n.supv_acct_open_bank_name, o.supv_acct_open_bank_name) as supv_acct_open_bank_name -- 监管账户开户行名称
    ,nvl(n.supv_acct_type_cd, o.supv_acct_type_cd) as supv_acct_type_cd -- 监管账户类型代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.adv_acct_id, o.adv_acct_id) as adv_acct_id -- 垫资账户编号
    ,nvl(n.adv_acct_name, o.adv_acct_name) as adv_acct_name -- 垫资账户名称
    ,nvl(n.adv_acct_open_bank_num, o.adv_acct_open_bank_num) as adv_acct_open_bank_num -- 垫资账户开户行号
    ,nvl(n.adv_acct_type_cd, o.adv_acct_type_cd) as adv_acct_type_cd -- 垫资账户类型代码
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(n.free_apv_tranbl_acct_flg, o.free_apv_tranbl_acct_flg) as free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.modif_tm, o.modif_tm) as modif_tm -- 修改时间
    ,nvl(n.matn_teller_id, o.matn_teller_id) as matn_teller_id -- 维护柜员编号
    ,nvl(n.apv_teller_id, o.apv_teller_id) as apv_teller_id -- 审批柜员编号
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
from ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.mercht_id <> n.mercht_id
        or o.mercht_name <> n.mercht_name
        or o.mercht_abbr <> n.mercht_abbr
        or o.white_list_ctrl_flg <> n.white_list_ctrl_flg
        or o.mercht_status_cd <> n.mercht_status_cd
        or o.supv_acct_id <> n.supv_acct_id
        or o.supv_acct_name <> n.supv_acct_name
        or o.supv_acct_open_bank_num <> n.supv_acct_open_bank_num
        or o.supv_acct_open_bank_name <> n.supv_acct_open_bank_name
        or o.supv_acct_type_cd <> n.supv_acct_type_cd
        or o.belong_org_id <> n.belong_org_id
        or o.adv_acct_id <> n.adv_acct_id
        or o.adv_acct_name <> n.adv_acct_name
        or o.adv_acct_open_bank_num <> n.adv_acct_open_bank_num
        or o.adv_acct_type_cd <> n.adv_acct_type_cd
        or o.flow_status_cd <> n.flow_status_cd
        or o.free_apv_tranbl_acct_flg <> n.free_apv_tranbl_acct_flg
        or o.create_tm <> n.create_tm
        or o.modif_tm <> n.modif_tm
        or o.matn_teller_id <> n.matn_teller_id
        or o.apv_teller_id <> n.apv_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_abbr -- 商户简称
    ,white_list_ctrl_flg -- 白名单控制标志
    ,mercht_status_cd -- 商户状态代码
    ,supv_acct_id -- 监管账户编号
    ,supv_acct_name -- 监管账户名称
    ,supv_acct_open_bank_num -- 监管账户开户行号
    ,supv_acct_open_bank_name -- 监管账户开户行名称
    ,supv_acct_type_cd -- 监管账户类型代码
    ,belong_org_id -- 所属机构编号
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,adv_acct_open_bank_num -- 垫资账户开户行号
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,flow_status_cd -- 流程状态代码
    ,free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,matn_teller_id -- 维护柜员编号
    ,apv_teller_id -- 审批柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,mercht_abbr -- 商户简称
    ,white_list_ctrl_flg -- 白名单控制标志
    ,mercht_status_cd -- 商户状态代码
    ,supv_acct_id -- 监管账户编号
    ,supv_acct_name -- 监管账户名称
    ,supv_acct_open_bank_num -- 监管账户开户行号
    ,supv_acct_open_bank_name -- 监管账户开户行名称
    ,supv_acct_type_cd -- 监管账户类型代码
    ,belong_org_id -- 所属机构编号
    ,adv_acct_id -- 垫资账户编号
    ,adv_acct_name -- 垫资账户名称
    ,adv_acct_open_bank_num -- 垫资账户开户行号
    ,adv_acct_type_cd -- 垫资账户类型代码
    ,flow_status_cd -- 流程状态代码
    ,free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,matn_teller_id -- 维护柜员编号
    ,apv_teller_id -- 审批柜员编号
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
    ,o.mercht_id -- 商户编号
    ,o.mercht_name -- 商户名称
    ,o.mercht_abbr -- 商户简称
    ,o.white_list_ctrl_flg -- 白名单控制标志
    ,o.mercht_status_cd -- 商户状态代码
    ,o.supv_acct_id -- 监管账户编号
    ,o.supv_acct_name -- 监管账户名称
    ,o.supv_acct_open_bank_num -- 监管账户开户行号
    ,o.supv_acct_open_bank_name -- 监管账户开户行名称
    ,o.supv_acct_type_cd -- 监管账户类型代码
    ,o.belong_org_id -- 所属机构编号
    ,o.adv_acct_id -- 垫资账户编号
    ,o.adv_acct_name -- 垫资账户名称
    ,o.adv_acct_open_bank_num -- 垫资账户开户行号
    ,o.adv_acct_type_cd -- 垫资账户类型代码
    ,o.flow_status_cd -- 流程状态代码
    ,o.free_apv_tranbl_acct_flg -- 免审批可转账标志
    ,o.create_tm -- 创建时间
    ,o.modif_tm -- 修改时间
    ,o.matn_teller_id -- 维护柜员编号
    ,o.apv_teller_id -- 审批柜员编号
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
from ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_bk o
    left join ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl d
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
--truncate table ${iml_schema}.agt_payfan_mercht_sign_info_h;
--alter table ${iml_schema}.agt_payfan_mercht_sign_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_payfan_mercht_sign_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_payfan_mercht_sign_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_payfan_mercht_sign_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_payfan_mercht_sign_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl;
alter table ${iml_schema}.agt_payfan_mercht_sign_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_payfan_mercht_sign_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_payfan_mercht_sign_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
