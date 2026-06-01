/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_abs_prtcptr_info_h_abssf1
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
alter table ${iml_schema}.pty_abs_prtcptr_info_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_abs_prtcptr_info_h partition for ('abssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_tm purge;
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op purge;
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,prtcptr_id -- 参与方编号
    ,prtcptr_name -- 参与方名称
    ,prtcptr_type_cd -- 参与方类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,bigamt_bank_no -- 大额行号
    ,bigamt_bank_name -- 大额行名
    ,rela_ps_name -- 关联人名称
    ,tel_num -- 电话号码
    ,rgst_emply_id -- 登记员工编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,modif_emply_id -- 修改员工编号
    ,modif_org_id -- 修改机构编号
    ,modif_dt -- 修改日期
    ,ts_flg -- 暂存标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_abs_prtcptr_info_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_abs_prtcptr_info_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_abs_prtcptr_info_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_rela_person_info-1
insert into ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,prtcptr_id -- 参与方编号
    ,prtcptr_name -- 参与方名称
    ,prtcptr_type_cd -- 参与方类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,bigamt_bank_no -- 大额行号
    ,bigamt_bank_name -- 大额行名
    ,rela_ps_name -- 关联人名称
    ,tel_num -- 电话号码
    ,rgst_emply_id -- 登记员工编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,modif_emply_id -- 修改员工编号
    ,modif_org_id -- 修改机构编号
    ,modif_dt -- 修改日期
    ,ts_flg -- 暂存标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.RELAPERSONID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELAPERSONID -- 参与方编号
    ,P1.RELAPERSONNAME -- 参与方名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.RELAPERSONTYPE END -- 参与方类型代码
    ,P1.ACCOUNTNO -- 账户编号
    ,P1.ACCOUNTNAME -- 账户名称
    ,P1.ACCOUNTBANK -- 开户行行号
    ,P1.LARGENUMBER -- 大额行号
    ,P1.LARGEBANKNAME -- 大额行名
    ,P1.CONTACT -- 关联人名称
    ,P1.CONTACTWAY -- 电话号码
    ,P1.INPUTUSERID -- 登记员工编号
    ,P1.INPUTORGID -- 登记机构编号
    ,${iml_schema}.dateformat_min(P1.INPUTDATE) -- 登记日期
    ,P1.UPDATEUSERID -- 修改员工编号
    ,P1.UPDATEORGID -- 修改机构编号
    ,${iml_schema}.dateformat_max(P1.UPDATEDATE) -- 修改日期
    ,DECODE(TRIM(P1.TEMPSAVEFLAG),null,'-','0','1','1','0',P1.TEMPSAVEFLAG) -- 暂存标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_rela_person_info' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_rela_person_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RELAPERSONTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ABSS'
        AND R1.SRC_TAB_EN_NAME= 'ABSS_ABS_RELA_PERSON_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'RELAPERSONTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_ABS_PRTCPTR_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRTCPTR_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_tm 
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
        into ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,prtcptr_id -- 参与方编号
    ,prtcptr_name -- 参与方名称
    ,prtcptr_type_cd -- 参与方类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,bigamt_bank_no -- 大额行号
    ,bigamt_bank_name -- 大额行名
    ,rela_ps_name -- 关联人名称
    ,tel_num -- 电话号码
    ,rgst_emply_id -- 登记员工编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,modif_emply_id -- 修改员工编号
    ,modif_org_id -- 修改机构编号
    ,modif_dt -- 修改日期
    ,ts_flg -- 暂存标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,prtcptr_id -- 参与方编号
    ,prtcptr_name -- 参与方名称
    ,prtcptr_type_cd -- 参与方类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,bigamt_bank_no -- 大额行号
    ,bigamt_bank_name -- 大额行名
    ,rela_ps_name -- 关联人名称
    ,tel_num -- 电话号码
    ,rgst_emply_id -- 登记员工编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,modif_emply_id -- 修改员工编号
    ,modif_org_id -- 修改机构编号
    ,modif_dt -- 修改日期
    ,ts_flg -- 暂存标志
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
    ,nvl(n.prtcptr_id, o.prtcptr_id) as prtcptr_id -- 参与方编号
    ,nvl(n.prtcptr_name, o.prtcptr_name) as prtcptr_name -- 参与方名称
    ,nvl(n.prtcptr_type_cd, o.prtcptr_type_cd) as prtcptr_type_cd -- 参与方类型代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_bank_no, o.open_bank_no) as open_bank_no -- 开户行行号
    ,nvl(n.bigamt_bank_no, o.bigamt_bank_no) as bigamt_bank_no -- 大额行号
    ,nvl(n.bigamt_bank_name, o.bigamt_bank_name) as bigamt_bank_name -- 大额行名
    ,nvl(n.rela_ps_name, o.rela_ps_name) as rela_ps_name -- 关联人名称
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.rgst_emply_id, o.rgst_emply_id) as rgst_emply_id -- 登记员工编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.modif_emply_id, o.modif_emply_id) as modif_emply_id -- 修改员工编号
    ,nvl(n.modif_org_id, o.modif_org_id) as modif_org_id -- 修改机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 修改日期
    ,nvl(n.ts_flg, o.ts_flg) as ts_flg -- 暂存标志
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
from ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_tm n
    full join (select * from ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.prtcptr_id <> n.prtcptr_id
        or o.prtcptr_name <> n.prtcptr_name
        or o.prtcptr_type_cd <> n.prtcptr_type_cd
        or o.acct_id <> n.acct_id
        or o.acct_name <> n.acct_name
        or o.open_bank_no <> n.open_bank_no
        or o.bigamt_bank_no <> n.bigamt_bank_no
        or o.bigamt_bank_name <> n.bigamt_bank_name
        or o.rela_ps_name <> n.rela_ps_name
        or o.tel_num <> n.tel_num
        or o.rgst_emply_id <> n.rgst_emply_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.modif_emply_id <> n.modif_emply_id
        or o.modif_org_id <> n.modif_org_id
        or o.modif_dt <> n.modif_dt
        or o.ts_flg <> n.ts_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,prtcptr_id -- 参与方编号
    ,prtcptr_name -- 参与方名称
    ,prtcptr_type_cd -- 参与方类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,bigamt_bank_no -- 大额行号
    ,bigamt_bank_name -- 大额行名
    ,rela_ps_name -- 关联人名称
    ,tel_num -- 电话号码
    ,rgst_emply_id -- 登记员工编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,modif_emply_id -- 修改员工编号
    ,modif_org_id -- 修改机构编号
    ,modif_dt -- 修改日期
    ,ts_flg -- 暂存标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,prtcptr_id -- 参与方编号
    ,prtcptr_name -- 参与方名称
    ,prtcptr_type_cd -- 参与方类型代码
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,open_bank_no -- 开户行行号
    ,bigamt_bank_no -- 大额行号
    ,bigamt_bank_name -- 大额行名
    ,rela_ps_name -- 关联人名称
    ,tel_num -- 电话号码
    ,rgst_emply_id -- 登记员工编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,modif_emply_id -- 修改员工编号
    ,modif_org_id -- 修改机构编号
    ,modif_dt -- 修改日期
    ,ts_flg -- 暂存标志
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
    ,o.prtcptr_id -- 参与方编号
    ,o.prtcptr_name -- 参与方名称
    ,o.prtcptr_type_cd -- 参与方类型代码
    ,o.acct_id -- 账户编号
    ,o.acct_name -- 账户名称
    ,o.open_bank_no -- 开户行行号
    ,o.bigamt_bank_no -- 大额行号
    ,o.bigamt_bank_name -- 大额行名
    ,o.rela_ps_name -- 关联人名称
    ,o.tel_num -- 电话号码
    ,o.rgst_emply_id -- 登记员工编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.modif_emply_id -- 修改员工编号
    ,o.modif_org_id -- 修改机构编号
    ,o.modif_dt -- 修改日期
    ,o.ts_flg -- 暂存标志
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
from ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_bk o
    left join ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl d
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
--truncate table ${iml_schema}.pty_abs_prtcptr_info_h;
--alter table ${iml_schema}.pty_abs_prtcptr_info_h truncate partition for ('abssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_abs_prtcptr_info_h') 
               and substr(subpartition_name,1,8)=upper('p_abssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_abs_prtcptr_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_abs_prtcptr_info_h modify partition p_abssf1 
add subpartition p_abssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_abs_prtcptr_info_h exchange subpartition p_abssf1_${batch_date} with table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl;
alter table ${iml_schema}.pty_abs_prtcptr_info_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_abs_prtcptr_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_tm purge;
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_op purge;
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_abs_prtcptr_info_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_abs_prtcptr_info_h', partname => 'p_abssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
