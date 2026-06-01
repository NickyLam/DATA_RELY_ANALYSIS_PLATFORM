/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_senior_man_family_mem_info_h_icmsf1
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
alter table ${iml_schema}.pty_senior_man_family_mem_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_senior_man_family_mem_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,senior_man_family_mem_id -- 高管家族成员编号
    ,senior_man_party_id -- 高管当事人编号
    ,family_mem_name -- 家族成员姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,work_unit_name -- 工作单位名称
    ,valid_flg -- 有效标志
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,local_corp_name -- 所在企业名称
    ,move_flg -- 迁移标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_senior_man_family_mem_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_senior_man_family_mem_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_senior_man_family_mem_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_customer_executives_family-1
insert into ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,senior_man_family_mem_id -- 高管家族成员编号
    ,senior_man_party_id -- 高管当事人编号
    ,family_mem_name -- 家族成员姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,work_unit_name -- 工作单位名称
    ,valid_flg -- 有效标志
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,local_corp_name -- 所在企业名称
    ,move_flg -- 迁移标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 当事人编号
    , '9999' -- 法人编号
    ,P1.SERIALNO -- 高管家族成员编号
    ,P1.RELASERIALNO -- 高管当事人编号
    ,P1.CUSTOMERNAME -- 家族成员姓名
    ,P1.CERTTYPE -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,nvl(trim(P1.RELATIONSHIP),'00000')  -- 关联关系类型代码
    ,P1.WORKNAME -- 工作单位名称
    ,DECODE(P1.STATUS,'1','1','2','0',P1.STATUS) -- 有效标志
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,P1.DESCRIBE -- 所在企业名称
    ,CASE WHEN TRIM(P1.MIGTFLAG) IS NOT NULL THEN '1' ELSE '0' END -- 迁移标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_customer_executives_family' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_customer_executives_family p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RELATIONSHIP= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_CUSTOMER_EXECUTIVES_FAMILY'
        AND R1.SRC_FIELD_EN_NAME= 'RELATIONSHIP'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_SENIOR_MAN_FAMILY_MEM_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PARTY_RELA_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,senior_man_family_mem_id
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
        into ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,senior_man_family_mem_id -- 高管家族成员编号
    ,senior_man_party_id -- 高管当事人编号
    ,family_mem_name -- 家族成员姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,work_unit_name -- 工作单位名称
    ,valid_flg -- 有效标志
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,local_corp_name -- 所在企业名称
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,senior_man_family_mem_id -- 高管家族成员编号
    ,senior_man_party_id -- 高管当事人编号
    ,family_mem_name -- 家族成员姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,work_unit_name -- 工作单位名称
    ,valid_flg -- 有效标志
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,local_corp_name -- 所在企业名称
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.senior_man_family_mem_id, o.senior_man_family_mem_id) as senior_man_family_mem_id -- 高管家族成员编号
    ,nvl(n.senior_man_party_id, o.senior_man_party_id) as senior_man_party_id -- 高管当事人编号
    ,nvl(n.family_mem_name, o.family_mem_name) as family_mem_name -- 家族成员姓名
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.party_rela_type_cd, o.party_rela_type_cd) as party_rela_type_cd -- 关联关系类型代码
    ,nvl(n.work_unit_name, o.work_unit_name) as work_unit_name -- 工作单位名称
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.local_corp_name, o.local_corp_name) as local_corp_name -- 所在企业名称
    ,nvl(n.move_flg, o.move_flg) as move_flg -- 迁移标志
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.senior_man_family_mem_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.senior_man_family_mem_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.senior_man_family_mem_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.senior_man_family_mem_id = n.senior_man_family_mem_id
where (
        o.party_id is null
        and o.lp_id is null
        and o.senior_man_family_mem_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.senior_man_family_mem_id is null
    )
    or (
        o.senior_man_party_id <> n.senior_man_party_id
        or o.family_mem_name <> n.family_mem_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.party_rela_type_cd <> n.party_rela_type_cd
        or o.work_unit_name <> n.work_unit_name
        or o.valid_flg <> n.valid_flg
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_org_id <> n.rgst_org_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.local_corp_name <> n.local_corp_name
        or o.move_flg <> n.move_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,senior_man_family_mem_id -- 高管家族成员编号
    ,senior_man_party_id -- 高管当事人编号
    ,family_mem_name -- 家族成员姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,work_unit_name -- 工作单位名称
    ,valid_flg -- 有效标志
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,local_corp_name -- 所在企业名称
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,senior_man_family_mem_id -- 高管家族成员编号
    ,senior_man_party_id -- 高管当事人编号
    ,family_mem_name -- 家族成员姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,party_rela_type_cd -- 关联关系类型代码
    ,work_unit_name -- 工作单位名称
    ,valid_flg -- 有效标志
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,rgst_org_id -- 登记机构编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,local_corp_name -- 所在企业名称
    ,move_flg -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.senior_man_family_mem_id -- 高管家族成员编号
    ,o.senior_man_party_id -- 高管当事人编号
    ,o.family_mem_name -- 家族成员姓名
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.party_rela_type_cd -- 关联关系类型代码
    ,o.work_unit_name -- 工作单位名称
    ,o.valid_flg -- 有效标志
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_dt -- 登记日期
    ,o.rgst_org_id -- 登记机构编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.local_corp_name -- 所在企业名称
    ,o.move_flg -- 迁移标志
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
from ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_bk o
    left join ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.senior_man_family_mem_id = n.senior_man_family_mem_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.senior_man_family_mem_id = d.senior_man_family_mem_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_senior_man_family_mem_info_h;
--alter table ${iml_schema}.pty_senior_man_family_mem_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_senior_man_family_mem_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_senior_man_family_mem_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_senior_man_family_mem_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_senior_man_family_mem_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl;
alter table ${iml_schema}.pty_senior_man_family_mem_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_senior_man_family_mem_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_op purge;
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_senior_man_family_mem_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_senior_man_family_mem_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
