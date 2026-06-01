/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_salary_plat_payoff_emply_info_mpcsf1
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
alter table ${iml_schema}.pty_salary_plat_payoff_emply_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_salary_plat_payoff_emply_info partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_tm purge;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op purge;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,postning_flg -- 在职标志
    ,start_use_flg -- 启用标志
    ,user_id -- 用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,emply_type_cd -- 员工类型代码
    ,acct_id -- 账户编号
    ,tel_num -- 电话号码
    ,corp_id -- 企业编号
    ,postn_id -- 职位编号
    ,org_id -- 组织编号
    ,post_id -- 岗位编号
    ,empyt_dt -- 入职日期
    ,out_corp_flg -- 退出公司标志
    ,dimission_status_cd -- 离职状态代码
    ,dimission_resume_flg -- 离职恢复标志
    ,jcm_stop_use_flg -- 运管端停用标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_salary_plat_payoff_emply_info partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_salary_plat_payoff_emply_info partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_salary_plat_payoff_emply_info partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a1wpm_employee_base_info-1
insert into ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,postning_flg -- 在职标志
    ,start_use_flg -- 启用标志
    ,user_id -- 用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,emply_type_cd -- 员工类型代码
    ,acct_id -- 账户编号
    ,tel_num -- 电话号码
    ,corp_id -- 企业编号
    ,postn_id -- 职位编号
    ,org_id -- 组织编号
    ,post_id -- 岗位编号
    ,empyt_dt -- 入职日期
    ,out_corp_flg -- 退出公司标志
    ,dimission_status_cd -- 离职状态代码
    ,dimission_resume_flg -- 离职恢复标志
    ,jcm_stop_use_flg -- 运管端停用标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '901002 '||P1.EMPLOYEE_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.EMPLOYEE_ID -- 员工编号
    ,P1.EMPLOYEE_NAME -- 员工姓名
    ,decode(P1.INCUMBENCY_FLAG,'Y','1','N','0',' ','-',P1.INCUMBENCY_FLAG) -- 在职标志
    ,decode(P1.ENABLE_FLAG,'Y','1','N','0',' ','-',P1.ENABLE_FLAG) -- 启用标志
    ,P1.USER_ID -- 用户编号
    ,nvl(trim(P1.CERT_TYPE),'0000') -- 证件类型代码
    ,P1.CERT_NO -- 证件号码
    ,decode(P1.EMPLOYEE_GENDER,' ','0','00','2','01','1',P1.EMPLOYEE_GENDER) -- 性别代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.EMPLOYEE_TYPE END -- 员工类型代码
    ,P1.ACCT_NO -- 账户编号
    ,P1.PHONE_NO -- 电话号码
    ,P1.COMPANY_ID -- 企业编号
    ,P1.RANK_ID -- 职位编号
    ,P1.ORGAN_ID -- 组织编号
    ,P1.POST_ID -- 岗位编号
    ,${iml_schema}.dateformat_min(P1.ENTRY_DATE) -- 入职日期
    ,decode(P1.QUIT_COMPANY_FLAG,'Y','1','N','0',' ','-',P1.QUIT_COMPANY_FLAG) -- 退出公司标志
    ,nvl(trim(P1.LEAVE_STATUS),'-') -- 离职状态代码
    ,decode(P1.RECOVER_FLAG,'Y','1','N','0',' ','-',P1.RECOVER_FLAG) -- 离职恢复标志
    ,decode(P1.MANAGE_FLAG,'Y','1','N','0',' ','-',P1.MANAGE_FLAG) -- 运管端停用标志
    ,${iml_schema}.dateformat_min(P1.CREATE_TIMESTAMP) -- 批次创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIMESTAMP) -- 批次更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1wpm_employee_base_info' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1wpm_employee_base_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.EMPLOYEE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1WPM_EMPLOYEE_BASE_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'EMPLOYEE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_SALARY_PLAT_PAYOFF_EMPLY_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EMPLY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_tm 
  	                                group by 
  	                                        party_id
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
        into ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,postning_flg -- 在职标志
    ,start_use_flg -- 启用标志
    ,user_id -- 用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,emply_type_cd -- 员工类型代码
    ,acct_id -- 账户编号
    ,tel_num -- 电话号码
    ,corp_id -- 企业编号
    ,postn_id -- 职位编号
    ,org_id -- 组织编号
    ,post_id -- 岗位编号
    ,empyt_dt -- 入职日期
    ,out_corp_flg -- 退出公司标志
    ,dimission_status_cd -- 离职状态代码
    ,dimission_resume_flg -- 离职恢复标志
    ,jcm_stop_use_flg -- 运管端停用标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,postning_flg -- 在职标志
    ,start_use_flg -- 启用标志
    ,user_id -- 用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,emply_type_cd -- 员工类型代码
    ,acct_id -- 账户编号
    ,tel_num -- 电话号码
    ,corp_id -- 企业编号
    ,postn_id -- 职位编号
    ,org_id -- 组织编号
    ,post_id -- 岗位编号
    ,empyt_dt -- 入职日期
    ,out_corp_flg -- 退出公司标志
    ,dimission_status_cd -- 离职状态代码
    ,dimission_resume_flg -- 离职恢复标志
    ,jcm_stop_use_flg -- 运管端停用标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
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
    ,nvl(n.emply_id, o.emply_id) as emply_id -- 员工编号
    ,nvl(n.emply_name, o.emply_name) as emply_name -- 员工姓名
    ,nvl(n.postning_flg, o.postning_flg) as postning_flg -- 在职标志
    ,nvl(n.start_use_flg, o.start_use_flg) as start_use_flg -- 启用标志
    ,nvl(n.user_id, o.user_id) as user_id -- 用户编号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.emply_type_cd, o.emply_type_cd) as emply_type_cd -- 员工类型代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 企业编号
    ,nvl(n.postn_id, o.postn_id) as postn_id -- 职位编号
    ,nvl(n.org_id, o.org_id) as org_id -- 组织编号
    ,nvl(n.post_id, o.post_id) as post_id -- 岗位编号
    ,nvl(n.empyt_dt, o.empyt_dt) as empyt_dt -- 入职日期
    ,nvl(n.out_corp_flg, o.out_corp_flg) as out_corp_flg -- 退出公司标志
    ,nvl(n.dimission_status_cd, o.dimission_status_cd) as dimission_status_cd -- 离职状态代码
    ,nvl(n.dimission_resume_flg, o.dimission_resume_flg) as dimission_resume_flg -- 离职恢复标志
    ,nvl(n.jcm_stop_use_flg, o.jcm_stop_use_flg) as jcm_stop_use_flg -- 运管端停用标志
    ,nvl(n.batch_create_dt, o.batch_create_dt) as batch_create_dt -- 批次创建日期
    ,nvl(n.batch_update_dt, o.batch_update_dt) as batch_update_dt -- 批次更新日期
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_tm n
    full join (select * from ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.emply_id <> n.emply_id
        or o.emply_name <> n.emply_name
        or o.postning_flg <> n.postning_flg
        or o.start_use_flg <> n.start_use_flg
        or o.user_id <> n.user_id
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.gender_cd <> n.gender_cd
        or o.emply_type_cd <> n.emply_type_cd
        or o.acct_id <> n.acct_id
        or o.tel_num <> n.tel_num
        or o.corp_id <> n.corp_id
        or o.postn_id <> n.postn_id
        or o.org_id <> n.org_id
        or o.post_id <> n.post_id
        or o.empyt_dt <> n.empyt_dt
        or o.out_corp_flg <> n.out_corp_flg
        or o.dimission_status_cd <> n.dimission_status_cd
        or o.dimission_resume_flg <> n.dimission_resume_flg
        or o.jcm_stop_use_flg <> n.jcm_stop_use_flg
        or o.batch_create_dt <> n.batch_create_dt
        or o.batch_update_dt <> n.batch_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,postning_flg -- 在职标志
    ,start_use_flg -- 启用标志
    ,user_id -- 用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,emply_type_cd -- 员工类型代码
    ,acct_id -- 账户编号
    ,tel_num -- 电话号码
    ,corp_id -- 企业编号
    ,postn_id -- 职位编号
    ,org_id -- 组织编号
    ,post_id -- 岗位编号
    ,empyt_dt -- 入职日期
    ,out_corp_flg -- 退出公司标志
    ,dimission_status_cd -- 离职状态代码
    ,dimission_resume_flg -- 离职恢复标志
    ,jcm_stop_use_flg -- 运管端停用标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,postning_flg -- 在职标志
    ,start_use_flg -- 启用标志
    ,user_id -- 用户编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,emply_type_cd -- 员工类型代码
    ,acct_id -- 账户编号
    ,tel_num -- 电话号码
    ,corp_id -- 企业编号
    ,postn_id -- 职位编号
    ,org_id -- 组织编号
    ,post_id -- 岗位编号
    ,empyt_dt -- 入职日期
    ,out_corp_flg -- 退出公司标志
    ,dimission_status_cd -- 离职状态代码
    ,dimission_resume_flg -- 离职恢复标志
    ,jcm_stop_use_flg -- 运管端停用标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
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
    ,o.emply_id -- 员工编号
    ,o.emply_name -- 员工姓名
    ,o.postning_flg -- 在职标志
    ,o.start_use_flg -- 启用标志
    ,o.user_id -- 用户编号
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.gender_cd -- 性别代码
    ,o.emply_type_cd -- 员工类型代码
    ,o.acct_id -- 账户编号
    ,o.tel_num -- 电话号码
    ,o.corp_id -- 企业编号
    ,o.postn_id -- 职位编号
    ,o.org_id -- 组织编号
    ,o.post_id -- 岗位编号
    ,o.empyt_dt -- 入职日期
    ,o.out_corp_flg -- 退出公司标志
    ,o.dimission_status_cd -- 离职状态代码
    ,o.dimission_resume_flg -- 离职恢复标志
    ,o.jcm_stop_use_flg -- 运管端停用标志
    ,o.batch_create_dt -- 批次创建日期
    ,o.batch_update_dt -- 批次更新日期
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
from ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_bk o
    left join ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_salary_plat_payoff_emply_info;
--alter table ${iml_schema}.pty_salary_plat_payoff_emply_info truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_salary_plat_payoff_emply_info') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_salary_plat_payoff_emply_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_salary_plat_payoff_emply_info modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_salary_plat_payoff_emply_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl;
alter table ${iml_schema}.pty_salary_plat_payoff_emply_info exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_salary_plat_payoff_emply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_tm purge;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_op purge;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_salary_plat_payoff_emply_info_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_salary_plat_payoff_emply_info', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
