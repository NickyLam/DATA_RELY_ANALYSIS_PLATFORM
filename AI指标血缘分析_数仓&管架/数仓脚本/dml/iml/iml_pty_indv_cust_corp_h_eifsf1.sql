/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_indv_cust_corp_h_eifsf1
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
alter table ${iml_schema}.pty_indv_cust_corp_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust_corp_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_corp_rela_cd -- 借款人与企业关系代码
    ,corp_cust_id -- 企业客户编号
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_addr -- 企业经营地址
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,legal_rep_name -- 法定代表人
    ,emply_number -- 职工人数
    ,bus_anl_inco -- 营业年收入
    ,tot_asset -- 总资产
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bl_induty_name -- 所属行业名称
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,init_create_dt -- 最初创建日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,update_chn_id -- 更新渠道编号
    ,update_sys_name -- 更新系统名称
    ,latest_update_dt -- 最新更新日期
    ,sorc_sys_name -- 源系统名称
    ,sorc_sys_chn_id -- 源系统渠道编号
    ,sorc_sys_create_dt -- 源系统创建日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust_corp_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust_corp_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust_corp_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_per_oper_entt_info-1
insert into ${iml_schema}.pty_indv_cust_corp_h_eifsf1_tm(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_corp_rela_cd -- 借款人与企业关系代码
    ,corp_cust_id -- 企业客户编号
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_addr -- 企业经营地址
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,legal_rep_name -- 法定代表人
    ,emply_number -- 职工人数
    ,bus_anl_inco -- 营业年收入
    ,tot_asset -- 总资产
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bl_induty_name -- 所属行业名称
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,init_create_dt -- 最初创建日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,update_chn_id -- 更新渠道编号
    ,update_sys_name -- 更新系统名称
    ,latest_update_dt -- 最新更新日期
    ,sorc_sys_name -- 源系统名称
    ,sorc_sys_chn_id -- 源系统渠道编号
    ,sorc_sys_create_dt -- 源系统创建日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 客户编号
    ,'9999' -- 法人编号
    ,P1.OPER_PERS_PTY_NAME -- 客户名称
    ,nvl(trim(P1.OPER_PERS_CERT_TYP),'0000') -- 证件类型代码
    ,P1.OPER_PERS_CERT_NUM -- 证件号码
    ,case when R1.TARGET_CD_VAl is not null then R1.TARGET_CD_VAL else '@'||P1.BRWER_AND_OPER_ENTT_RELA end -- 借款人与企业关系代码
    ,P1.OPER_ENTT_PTY_ID -- 企业客户编号
    ,P1.OPER_ENTT_PTY_NAME -- 企业名称
    ,nvl(trim(P1.OPER_ENTT_DOC_TYP),'0000') -- 企业证件类型代码
    ,P1.OPER_ENTT_DOC_NUM -- 企业证件号码
    ,${iml_schema}.dateformat_max2(P1.OPER_ENTT_DOC_DUE_DATE) -- 企业证件到期日期
    ,P1.CORP_LOC -- 企业经营地址
    ,${iml_schema}.dateformat_min(P1.CORP_FOUND_DT) -- 企业成立日期
    ,nvl(trim(P1.CORP_SIZE_CD),'0') -- 企业规模代码
    ,P1.LEGAL_REP_NAME -- 法定代表人
    ,P1.CORP_EMPLY_PERSON_CNT -- 职工人数
    ,P1.CORP_YEAR_IN -- 营业年收入
    ,P1.CORP_TOTL_ASSET -- 总资产
    ,nvl(trim(P1.BELONG_INDUS_CD),'-') -- 所属行业类型代码
    ,P1.BLNG_INDUS_NAME -- 所属行业名称
    ,P1.CREATE_TE -- 创建柜员编号
    ,P1.CREATE_ORG -- 创建机构编号
    ,P1.CREATED_TS -- 最初创建日期
    ,P1.LAST_UPDATED_TE -- 更新柜员编号
    ,P1.LAST_UPDATED_ORG -- 更新机构编号
    ,nvl(trim(P1.LAST_SYSTEM_ID),'0000') -- 更新渠道编号
    ,P1.LAST_UPDATED_SRC_SYS_NUM -- 更新系统名称
    ,P1.LAST_UPDATED_TS -- 最新更新日期
    ,P1.SRC_SYS_NUM -- 源系统名称
    ,nvl(trim(P1.INIT_SYSTEM_ID),'0000') -- 源系统渠道编号
    ,P1.INIT_CREATED_TS -- 源系统创建日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_oper_entt_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_oper_entt_info p1
    left join ${iol_schema}.eifs_t00_per_cust_no_ref p2 
	on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p2.updated_ts = to_date('99991231', 'yyyymmdd')
   and least(to_char(p2.LAST_UPDATED_TS,'yyyymmdd'),to_char(nvl(p2.INIT_CREATED_TS,to_date('00010101','yyyymmdd')),'yyyymmdd')) <= '${batch_date}'
    left join ${iml_schema}.REF_PUB_CD_MAP R1 
	on P1.BRWER_AND_OPER_ENTT_RELA = R1.SRC_CODE_VAL
   and R1.SORC_SYS_CD= 'EIFS'
   and R1.SRC_TAB_EN_NAME= 'EIFS_T01_PER_OPER_ENTT_INFO'
   and R1.SRC_FIELD_EN_NAME= 'BRWER_AND_OPER_ENTT_RELA'
   and R1.TARGET_TAB_EN_NAME= 'PTY_INDV_CUST_CORP_H'
   and R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_CORP_RELA_CD'
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p1.end_dt > to_date('${batch_date}','yyyymmdd')
   and p1.updated_ts = to_date('99991231', 'yyyymmdd')
   and least(to_char(P1.LAST_UPDATED_TS,'yyyymmdd'),to_char(nvl(P1.INIT_CREATED_TS,to_date('00010101','yyyymmdd')),'yyyymmdd')) <= '${batch_date}'
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_indv_cust_corp_h_eifsf1_tm 
  	                                group by 
  	                                        cust_id
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
        into ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl(
            cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_corp_rela_cd -- 借款人与企业关系代码
    ,corp_cust_id -- 企业客户编号
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_addr -- 企业经营地址
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,legal_rep_name -- 法定代表人
    ,emply_number -- 职工人数
    ,bus_anl_inco -- 营业年收入
    ,tot_asset -- 总资产
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bl_induty_name -- 所属行业名称
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,init_create_dt -- 最初创建日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,update_chn_id -- 更新渠道编号
    ,update_sys_name -- 更新系统名称
    ,latest_update_dt -- 最新更新日期
    ,sorc_sys_name -- 源系统名称
    ,sorc_sys_chn_id -- 源系统渠道编号
    ,sorc_sys_create_dt -- 源系统创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op(
            cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_corp_rela_cd -- 借款人与企业关系代码
    ,corp_cust_id -- 企业客户编号
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_addr -- 企业经营地址
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,legal_rep_name -- 法定代表人
    ,emply_number -- 职工人数
    ,bus_anl_inco -- 营业年收入
    ,tot_asset -- 总资产
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bl_induty_name -- 所属行业名称
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,init_create_dt -- 最初创建日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,update_chn_id -- 更新渠道编号
    ,update_sys_name -- 更新系统名称
    ,latest_update_dt -- 最新更新日期
    ,sorc_sys_name -- 源系统名称
    ,sorc_sys_chn_id -- 源系统渠道编号
    ,sorc_sys_create_dt -- 源系统创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cust_corp_rela_cd, o.cust_corp_rela_cd) as cust_corp_rela_cd -- 借款人与企业关系代码
    ,nvl(n.corp_cust_id, o.corp_cust_id) as corp_cust_id -- 企业客户编号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 企业名称
    ,nvl(n.corp_cert_type_cd, o.corp_cert_type_cd) as corp_cert_type_cd -- 企业证件类型代码
    ,nvl(n.corp_cert_no, o.corp_cert_no) as corp_cert_no -- 企业证件号码
    ,nvl(n.corp_cert_exp_dt, o.corp_cert_exp_dt) as corp_cert_exp_dt -- 企业证件到期日期
    ,nvl(n.corp_mang_addr, o.corp_mang_addr) as corp_mang_addr -- 企业经营地址
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人
    ,nvl(n.emply_number, o.emply_number) as emply_number -- 职工人数
    ,nvl(n.bus_anl_inco, o.bus_anl_inco) as bus_anl_inco -- 营业年收入
    ,nvl(n.tot_asset, o.tot_asset) as tot_asset -- 总资产
    ,nvl(n.bl_induty_type_cd, o.bl_induty_type_cd) as bl_induty_type_cd -- 所属行业类型代码
    ,nvl(n.bl_induty_name, o.bl_induty_name) as bl_induty_name -- 所属行业名称
    ,nvl(n.create_teller_id, o.create_teller_id) as create_teller_id -- 创建柜员编号
    ,nvl(n.create_org_id, o.create_org_id) as create_org_id -- 创建机构编号
    ,nvl(n.init_create_dt, o.init_create_dt) as init_create_dt -- 最初创建日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.update_chn_id, o.update_chn_id) as update_chn_id -- 更新渠道编号
    ,nvl(n.update_sys_name, o.update_sys_name) as update_sys_name -- 更新系统名称
    ,nvl(n.latest_update_dt, o.latest_update_dt) as latest_update_dt -- 最新更新日期
    ,nvl(n.sorc_sys_name, o.sorc_sys_name) as sorc_sys_name -- 源系统名称
    ,nvl(n.sorc_sys_chn_id, o.sorc_sys_chn_id) as sorc_sys_chn_id -- 源系统渠道编号
    ,nvl(n.sorc_sys_create_dt, o.sorc_sys_create_dt) as sorc_sys_create_dt -- 源系统创建日期
    ,case when
            n.cust_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust_corp_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_indv_cust_corp_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cust_id = n.cust_id
            and o.lp_id = n.lp_id
where (
        o.cust_id is null
        and o.lp_id is null
    )
    or (
        n.cust_id is null
        and n.lp_id is null
    )
    or (
        o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.cust_corp_rela_cd <> n.cust_corp_rela_cd
        or o.corp_cust_id <> n.corp_cust_id
        or o.corp_name <> n.corp_name
        or o.corp_cert_type_cd <> n.corp_cert_type_cd
        or o.corp_cert_no <> n.corp_cert_no
        or o.corp_cert_exp_dt <> n.corp_cert_exp_dt
        or o.corp_mang_addr <> n.corp_mang_addr
        or o.corp_found_dt <> n.corp_found_dt
        or o.corp_size_cd <> n.corp_size_cd
        or o.legal_rep_name <> n.legal_rep_name
        or o.emply_number <> n.emply_number
        or o.bus_anl_inco <> n.bus_anl_inco
        or o.tot_asset <> n.tot_asset
        or o.bl_induty_type_cd <> n.bl_induty_type_cd
        or o.bl_induty_name <> n.bl_induty_name
        or o.create_teller_id <> n.create_teller_id
        or o.create_org_id <> n.create_org_id
        or o.init_create_dt <> n.init_create_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.update_chn_id <> n.update_chn_id
        or o.update_sys_name <> n.update_sys_name
        or o.latest_update_dt <> n.latest_update_dt
        or o.sorc_sys_name <> n.sorc_sys_name
        or o.sorc_sys_chn_id <> n.sorc_sys_chn_id
        or o.sorc_sys_create_dt <> n.sorc_sys_create_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl(
            cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_corp_rela_cd -- 借款人与企业关系代码
    ,corp_cust_id -- 企业客户编号
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_addr -- 企业经营地址
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,legal_rep_name -- 法定代表人
    ,emply_number -- 职工人数
    ,bus_anl_inco -- 营业年收入
    ,tot_asset -- 总资产
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bl_induty_name -- 所属行业名称
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,init_create_dt -- 最初创建日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,update_chn_id -- 更新渠道编号
    ,update_sys_name -- 更新系统名称
    ,latest_update_dt -- 最新更新日期
    ,sorc_sys_name -- 源系统名称
    ,sorc_sys_chn_id -- 源系统渠道编号
    ,sorc_sys_create_dt -- 源系统创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op(
            cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_corp_rela_cd -- 借款人与企业关系代码
    ,corp_cust_id -- 企业客户编号
    ,corp_name -- 企业名称
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,corp_cert_exp_dt -- 企业证件到期日期
    ,corp_mang_addr -- 企业经营地址
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,legal_rep_name -- 法定代表人
    ,emply_number -- 职工人数
    ,bus_anl_inco -- 营业年收入
    ,tot_asset -- 总资产
    ,bl_induty_type_cd -- 所属行业类型代码
    ,bl_induty_name -- 所属行业名称
    ,create_teller_id -- 创建柜员编号
    ,create_org_id -- 创建机构编号
    ,init_create_dt -- 最初创建日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,update_chn_id -- 更新渠道编号
    ,update_sys_name -- 更新系统名称
    ,latest_update_dt -- 最新更新日期
    ,sorc_sys_name -- 源系统名称
    ,sorc_sys_chn_id -- 源系统渠道编号
    ,sorc_sys_create_dt -- 源系统创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_id -- 客户编号
    ,o.lp_id -- 法人编号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.cust_corp_rela_cd -- 借款人与企业关系代码
    ,o.corp_cust_id -- 企业客户编号
    ,o.corp_name -- 企业名称
    ,o.corp_cert_type_cd -- 企业证件类型代码
    ,o.corp_cert_no -- 企业证件号码
    ,o.corp_cert_exp_dt -- 企业证件到期日期
    ,o.corp_mang_addr -- 企业经营地址
    ,o.corp_found_dt -- 企业成立日期
    ,o.corp_size_cd -- 企业规模代码
    ,o.legal_rep_name -- 法定代表人
    ,o.emply_number -- 职工人数
    ,o.bus_anl_inco -- 营业年收入
    ,o.tot_asset -- 总资产
    ,o.bl_induty_type_cd -- 所属行业类型代码
    ,o.bl_induty_name -- 所属行业名称
    ,o.create_teller_id -- 创建柜员编号
    ,o.create_org_id -- 创建机构编号
    ,o.init_create_dt -- 最初创建日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.update_chn_id -- 更新渠道编号
    ,o.update_sys_name -- 更新系统名称
    ,o.latest_update_dt -- 最新更新日期
    ,o.sorc_sys_name -- 源系统名称
    ,o.sorc_sys_chn_id -- 源系统渠道编号
    ,o.sorc_sys_create_dt -- 源系统创建日期
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
from ${iml_schema}.pty_indv_cust_corp_h_eifsf1_bk o
    left join ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op n
        on
            o.cust_id = n.cust_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl d
        on
            o.cust_id = d.cust_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_indv_cust_corp_h;
--alter table ${iml_schema}.pty_indv_cust_corp_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_indv_cust_corp_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_indv_cust_corp_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_indv_cust_corp_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_indv_cust_corp_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl;
alter table ${iml_schema}.pty_indv_cust_corp_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_indv_cust_corp_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_indv_cust_corp_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_indv_cust_corp_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
