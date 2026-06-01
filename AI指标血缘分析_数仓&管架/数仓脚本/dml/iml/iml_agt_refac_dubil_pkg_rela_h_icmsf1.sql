/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_refac_dubil_pkg_rela_h_icmsf1
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
alter table ${iml_schema}.agt_refac_dubil_pkg_rela_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_dubil_pkg_rela_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,apv_flow_num -- 审批流水号
    ,batch_pkg_id -- 批次包编号
    ,in_pool_idf_cd -- 入池标识代码
    ,in_pool_org_cd -- 入池机构代码
    ,actl_loan_distr_dt -- 实际贷款发放日期
    ,actl_loan_termnt_dt -- 实际贷款终止日期
    ,last_year_bus_inco -- 上年末营业收入
    ,corp_asset_tot -- 企业资产总额(万元)
    ,indus_type_cd -- 行业类型代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_size_cd -- 企业规模代码
    ,exec_int_rat -- 执行利率
    ,corp_number -- 企业人数
    ,loan_kind_cd -- 贷款种类代码
    ,mang_main_crdt_id -- 经营主体信用代码
    ,remark -- 备注
    ,move_remark -- 迁移备注
    ,rzxz_indus_type_cd	-- 支小再行业类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_dubil_pkg_rela_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_dubil_pkg_rela_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_refac_dubil_pkg_rela_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zxz_iqp_bill_rel-1
insert into ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,apv_flow_num -- 审批流水号
    ,batch_pkg_id -- 批次包编号
    ,in_pool_idf_cd -- 入池标识代码
    ,in_pool_org_cd -- 入池机构代码
    ,actl_loan_distr_dt -- 实际贷款发放日期
    ,actl_loan_termnt_dt -- 实际贷款终止日期
    ,last_year_bus_inco -- 上年末营业收入
    ,corp_asset_tot -- 企业资产总额(万元)
    ,indus_type_cd -- 行业类型代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_size_cd -- 企业规模代码
    ,exec_int_rat -- 执行利率
    ,corp_number -- 企业人数
    ,loan_kind_cd -- 贷款种类代码
    ,mang_main_crdt_id -- 经营主体信用代码
    ,move_remark -- 备注
    ,remark -- 迁移备注
    ,rzxz_indus_type_cd	-- 支小再行业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.BILLNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BILLNO -- 借据编号
    ,P1.SERNO -- 审批流水号
    ,P1.PACKAGENO -- 批次包编号
    ,nvl(trim(P1.INPOOLFLAG),'-') -- 入池标识代码
    ,nvl(trim(P1.INPOOLORGID),'-') -- 入池机构代码
    ,P1.PRACTICALSTARTDATE -- 实际贷款发放日期
    ,P1.PRACTICALENDDATE -- 实际贷款终止日期
    ,P1.OPERREVE -- 上年末营业收入
    ,P1.TOTALASSETS -- 企业资产总额(万元)
    ,nvl(trim(P1.ZXZINDUSTRY),'-') -- 行业类型代码
    ,P1.PURPOSE -- 贷款用途描述
    ,nvl(trim(P1.COMPSIZE),'-') -- 企业规模代码
    ,P1.EXECUTERATE -- 执行利率
    ,P1.WORKERSNUM -- 企业人数
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LOANDTYPE END  -- 贷款种类代码
    ,P1.ECONOMICCERTID -- 经营主体信用代码
    ,P1.MIGTFLAG -- 备注
    ,P1.REMARK -- 迁移备注
    ,P1.ZXZMAPINDUSTRY	-- 支小再行业类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zxz_iqp_bill_rel' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zxz_iqp_bill_rel p1
left join ${iml_schema}.ref_pub_cd_map r1 on P1.LOANDTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_ZXZ_IQP_BILL_REL'
        AND R1.SRC_FIELD_EN_NAME= 'LOANDTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_REFAC_DUBIL_PKG_RELA_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_KIND_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                                        ,apv_flow_num
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
        into ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,apv_flow_num -- 审批流水号
    ,batch_pkg_id -- 批次包编号
    ,in_pool_idf_cd -- 入池标识代码
    ,in_pool_org_cd -- 入池机构代码
    ,actl_loan_distr_dt -- 实际贷款发放日期
    ,actl_loan_termnt_dt -- 实际贷款终止日期
    ,last_year_bus_inco -- 上年末营业收入
    ,corp_asset_tot -- 企业资产总额(万元)
    ,indus_type_cd -- 行业类型代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_size_cd -- 企业规模代码
    ,exec_int_rat -- 执行利率
    ,corp_number -- 企业人数
    ,loan_kind_cd -- 贷款种类代码
    ,mang_main_crdt_id -- 经营主体信用代码
    ,remark -- 备注
    ,move_remark -- 迁移备注
    ,rzxz_indus_type_cd	-- 支小再行业类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,apv_flow_num -- 审批流水号
    ,batch_pkg_id -- 批次包编号
    ,in_pool_idf_cd -- 入池标识代码
    ,in_pool_org_cd -- 入池机构代码
    ,actl_loan_distr_dt -- 实际贷款发放日期
    ,actl_loan_termnt_dt -- 实际贷款终止日期
    ,last_year_bus_inco -- 上年末营业收入
    ,corp_asset_tot -- 企业资产总额(万元)
    ,indus_type_cd -- 行业类型代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_size_cd -- 企业规模代码
    ,exec_int_rat -- 执行利率
    ,corp_number -- 企业人数
    ,loan_kind_cd -- 贷款种类代码
    ,mang_main_crdt_id -- 经营主体信用代码
    ,remark -- 备注
    ,move_remark -- 迁移备注
    ,rzxz_indus_type_cd	-- 支小再行业类型代码
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
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.apv_flow_num, o.apv_flow_num) as apv_flow_num -- 审批流水号
    ,nvl(n.batch_pkg_id, o.batch_pkg_id) as batch_pkg_id -- 批次包编号
    ,nvl(n.in_pool_idf_cd, o.in_pool_idf_cd) as in_pool_idf_cd -- 入池标识代码
    ,nvl(n.in_pool_org_cd, o.in_pool_org_cd) as in_pool_org_cd -- 入池机构代码
    ,nvl(n.actl_loan_distr_dt, o.actl_loan_distr_dt) as actl_loan_distr_dt -- 实际贷款发放日期
    ,nvl(n.actl_loan_termnt_dt, o.actl_loan_termnt_dt) as actl_loan_termnt_dt -- 实际贷款终止日期
    ,nvl(n.last_year_bus_inco, o.last_year_bus_inco) as last_year_bus_inco -- 上年末营业收入
    ,nvl(n.corp_asset_tot, o.corp_asset_tot) as corp_asset_tot -- 企业资产总额(万元)
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.loan_usage_descb, o.loan_usage_descb) as loan_usage_descb -- 贷款用途描述
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.corp_number, o.corp_number) as corp_number -- 企业人数
    ,nvl(n.loan_kind_cd, o.loan_kind_cd) as loan_kind_cd -- 贷款种类代码
    ,nvl(n.mang_main_crdt_id, o.mang_main_crdt_id) as mang_main_crdt_id -- 经营主体信用代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.rzxz_indus_type_cd, o.rzxz_indus_type_cd) as rzxz_indus_type_cd -- 支小再行业类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.apv_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.apv_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.apv_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.apv_flow_num = n.apv_flow_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
        and o.apv_flow_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
        and n.apv_flow_num is null
    )
    or (
        o.batch_pkg_id <> n.batch_pkg_id
        or o.in_pool_idf_cd <> n.in_pool_idf_cd
        or o.in_pool_org_cd <> n.in_pool_org_cd
        or o.actl_loan_distr_dt <> n.actl_loan_distr_dt
        or o.actl_loan_termnt_dt <> n.actl_loan_termnt_dt
        or o.last_year_bus_inco <> n.last_year_bus_inco
        or o.corp_asset_tot <> n.corp_asset_tot
        or o.indus_type_cd <> n.indus_type_cd
        or o.loan_usage_descb <> n.loan_usage_descb
        or o.corp_size_cd <> n.corp_size_cd
        or o.exec_int_rat <> n.exec_int_rat
        or o.corp_number <> n.corp_number
        or o.loan_kind_cd <> n.loan_kind_cd
        or o.mang_main_crdt_id <> n.mang_main_crdt_id
        or o.remark <> n.remark
        or o.move_remark <> n.move_remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,apv_flow_num -- 审批流水号
    ,batch_pkg_id -- 批次包编号
    ,in_pool_idf_cd -- 入池标识代码
    ,in_pool_org_cd -- 入池机构代码
    ,actl_loan_distr_dt -- 实际贷款发放日期
    ,actl_loan_termnt_dt -- 实际贷款终止日期
    ,last_year_bus_inco -- 上年末营业收入
    ,corp_asset_tot -- 企业资产总额(万元)
    ,indus_type_cd -- 行业类型代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_size_cd -- 企业规模代码
    ,exec_int_rat -- 执行利率
    ,corp_number -- 企业人数
    ,loan_kind_cd -- 贷款种类代码
    ,mang_main_crdt_id -- 经营主体信用代码
    ,remark -- 备注
    ,move_remark -- 迁移备注
    ,rzxz_indus_type_cd	-- 支小再行业类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,apv_flow_num -- 审批流水号
    ,batch_pkg_id -- 批次包编号
    ,in_pool_idf_cd -- 入池标识代码
    ,in_pool_org_cd -- 入池机构代码
    ,actl_loan_distr_dt -- 实际贷款发放日期
    ,actl_loan_termnt_dt -- 实际贷款终止日期
    ,last_year_bus_inco -- 上年末营业收入
    ,corp_asset_tot -- 企业资产总额(万元)
    ,indus_type_cd -- 行业类型代码
    ,loan_usage_descb -- 贷款用途描述
    ,corp_size_cd -- 企业规模代码
    ,exec_int_rat -- 执行利率
    ,corp_number -- 企业人数
    ,loan_kind_cd -- 贷款种类代码
    ,mang_main_crdt_id -- 经营主体信用代码
    ,remark -- 备注
    ,move_remark -- 迁移备注
    ,rzxz_indus_type_cd	-- 支小再行业类型代码
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
    ,o.dubil_id -- 借据编号
    ,o.apv_flow_num -- 审批流水号
    ,o.batch_pkg_id -- 批次包编号
    ,o.in_pool_idf_cd -- 入池标识代码
    ,o.in_pool_org_cd -- 入池机构代码
    ,o.actl_loan_distr_dt -- 实际贷款发放日期
    ,o.actl_loan_termnt_dt -- 实际贷款终止日期
    ,o.last_year_bus_inco -- 上年末营业收入
    ,o.corp_asset_tot -- 企业资产总额(万元)
    ,o.indus_type_cd -- 行业类型代码
    ,o.loan_usage_descb -- 贷款用途描述
    ,o.corp_size_cd -- 企业规模代码
    ,o.exec_int_rat -- 执行利率
    ,o.corp_number -- 企业人数
    ,o.loan_kind_cd -- 贷款种类代码
    ,o.mang_main_crdt_id -- 经营主体信用代码
    ,o.remark -- 备注
    ,o.move_remark -- 迁移备注
    ,o.rzxz_indus_type_cd	-- 支小再行业类型代码
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
from ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_bk o
    left join ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.apv_flow_num = n.apv_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
            and o.apv_flow_num = d.apv_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_refac_dubil_pkg_rela_h;
--alter table ${iml_schema}.agt_refac_dubil_pkg_rela_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_refac_dubil_pkg_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_refac_dubil_pkg_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_refac_dubil_pkg_rela_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_refac_dubil_pkg_rela_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl;
alter table ${iml_schema}.agt_refac_dubil_pkg_rela_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_refac_dubil_pkg_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_refac_dubil_pkg_rela_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_refac_dubil_pkg_rela_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
