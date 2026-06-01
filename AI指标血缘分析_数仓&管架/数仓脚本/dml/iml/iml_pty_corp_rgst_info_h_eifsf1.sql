/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_rgst_info_h_eifsf1
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
alter table ${iml_schema}.pty_corp_rgst_info_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_rgst_info_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,found_dt -- 成立日期
    ,rgst_cd -- 登记注册代码
    ,oper_field_prop_cd -- 经营场地所有权代码
    ,oper_range -- 经营范围
    ,corp_rgst_type_cd -- 企业登记注册类型代码
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,rgst_cap -- 注册资本
    ,rgst_cap_curr_cd -- 注册资本币种代码
    ,asset_tot -- 集团资产总额
    ,leg_oper_situ -- 合法经营情况
    ,oper_field_area -- 经营场地面积
    ,major_prod_serv_situ -- 主要产品和服务情况
    ,work_rg_dist_cd -- 办公地区行政区划代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_rgst_info_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_rgst_info_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_rgst_info_h partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_corp_cust_info-1
insert into ${iml_schema}.pty_corp_rgst_info_h_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,found_dt -- 成立日期
    ,rgst_cd -- 登记注册代码
    ,oper_field_prop_cd -- 经营场地所有权代码
    ,oper_range -- 经营范围
    ,corp_rgst_type_cd -- 企业登记注册类型代码
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,rgst_cap -- 注册资本
    ,rgst_cap_curr_cd -- 注册资本币种代码
    ,asset_tot -- 集团资产总额
    ,leg_oper_situ -- 合法经营情况
    ,oper_field_area -- 经营场地面积
    ,major_prod_serv_situ -- 主要产品和服务情况
    ,work_rg_dist_cd -- 办公地区行政区划代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CORP_FOUND_DT) -- 成立日期
    ,NVL(NVL(P3.CERT_NUM,P4.CERT_NUM),' ') -- 登记注册代码
    ,NVL(TRIM(P1.OPER_PLACE_PROP_CD),'0') -- 经营场地所有权代码
    ,P1.OPER_BIZ -- 经营范围
    ,NVL(TRIM(P1.RGST_TYPE_CD),'900') -- 企业登记注册类型代码
    ,P1.ACTL_RECV_CAP -- 实收资本
    ,NVL(TRIM(P1.PAIDCAPITAL_CURRENCY),'-') -- 实收资本币种代码
    ,NVL(trim(P5.NATION_CD),'XXX') -- 投资方国家代码
    ,P1.RGST_CAP -- 注册资本
    ,NVL(TRIM(P1.REG_CAPITAL_CURRENCY),'CNY') -- 注册资本币种代码
    ,P1.CORP_TOTL_ASSET -- 集团资产总额
    ,' ' -- 合法经营情况
    ,TO_NUMBER(nvl(trim(regexp_substr(p1.OPER_PLACE_AREA, '[0-9.]+')),0)) -- 经营场地面积
    ,' ' -- 主要产品和服务情况
    ,P1.WORK_REGION -- 办公地区行政区划代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
    left join (select t1.*,row_number() over(partition by party_id,cert_type_cd order by t1.updated_ts desc) as rid from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1 where  t1.cert_type_cd='2313' and to_date(to_char(t1.updated_ts,'yyyymmdd'),'yyyymmdd')> to_date('${batch_date}','yyyymmdd') and t1.start_dt<= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')  ) p3 on P1.PARTY_ID=P3.PARTY_ID AND P3.RID=1
    left join (select t1.*,row_number() over(partition by party_id,cert_type_cd order by t1.updated_ts desc) as rid from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1 where  t1.cert_type_cd='2010' and to_date(to_char(t1.updated_ts,'yyyymmdd'),'yyyymmdd')> to_date('${batch_date}','yyyymmdd')
and t1.start_dt<= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')) p4 on P1.PARTY_ID=P4.PARTY_ID AND P4.RID=1
    left join ${iol_schema}.eifs_t00_party_pub_info p5 on P1.PARTY_ID=P5.PARTY_ID AND P5.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P5.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_corp_rgst_info_h_eifsf1_tm 
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
        into ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,found_dt -- 成立日期
    ,rgst_cd -- 登记注册代码
    ,oper_field_prop_cd -- 经营场地所有权代码
    ,oper_range -- 经营范围
    ,corp_rgst_type_cd -- 企业登记注册类型代码
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,rgst_cap -- 注册资本
    ,rgst_cap_curr_cd -- 注册资本币种代码
    ,asset_tot -- 集团资产总额
    ,leg_oper_situ -- 合法经营情况
    ,oper_field_area -- 经营场地面积
    ,major_prod_serv_situ -- 主要产品和服务情况
    ,work_rg_dist_cd -- 办公地区行政区划代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,found_dt -- 成立日期
    ,rgst_cd -- 登记注册代码
    ,oper_field_prop_cd -- 经营场地所有权代码
    ,oper_range -- 经营范围
    ,corp_rgst_type_cd -- 企业登记注册类型代码
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,rgst_cap -- 注册资本
    ,rgst_cap_curr_cd -- 注册资本币种代码
    ,asset_tot -- 集团资产总额
    ,leg_oper_situ -- 合法经营情况
    ,oper_field_area -- 经营场地面积
    ,major_prod_serv_situ -- 主要产品和服务情况
    ,work_rg_dist_cd -- 办公地区行政区划代码
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
    ,nvl(n.found_dt, o.found_dt) as found_dt -- 成立日期
    ,nvl(n.rgst_cd, o.rgst_cd) as rgst_cd -- 登记注册代码
    ,nvl(n.oper_field_prop_cd, o.oper_field_prop_cd) as oper_field_prop_cd -- 经营场地所有权代码
    ,nvl(n.oper_range, o.oper_range) as oper_range -- 经营范围
    ,nvl(n.corp_rgst_type_cd, o.corp_rgst_type_cd) as corp_rgst_type_cd -- 企业登记注册类型代码
    ,nvl(n.paid_in_capital, o.paid_in_capital) as paid_in_capital -- 实收资本
    ,nvl(n.paid_in_capital_curr_cd, o.paid_in_capital_curr_cd) as paid_in_capital_curr_cd -- 实收资本币种代码
    ,nvl(n.invtor_cty_cd, o.invtor_cty_cd) as invtor_cty_cd -- 投资方国家代码
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资本
    ,nvl(n.rgst_cap_curr_cd, o.rgst_cap_curr_cd) as rgst_cap_curr_cd -- 注册资本币种代码
    ,nvl(n.asset_tot, o.asset_tot) as asset_tot -- 集团资产总额
    ,nvl(n.leg_oper_situ, o.leg_oper_situ) as leg_oper_situ -- 合法经营情况
    ,nvl(n.oper_field_area, o.oper_field_area) as oper_field_area -- 经营场地面积
    ,nvl(n.major_prod_serv_situ, o.major_prod_serv_situ) as major_prod_serv_situ -- 主要产品和服务情况
    ,nvl(n.work_rg_dist_cd, o.work_rg_dist_cd) as work_rg_dist_cd -- 办公地区行政区划代码
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
from ${iml_schema}.pty_corp_rgst_info_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_corp_rgst_info_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.found_dt <> n.found_dt
        or o.rgst_cd <> n.rgst_cd
        or o.oper_field_prop_cd <> n.oper_field_prop_cd
        or o.oper_range <> n.oper_range
        or o.corp_rgst_type_cd <> n.corp_rgst_type_cd
        or o.paid_in_capital <> n.paid_in_capital
        or o.paid_in_capital_curr_cd <> n.paid_in_capital_curr_cd
        or o.invtor_cty_cd <> n.invtor_cty_cd
        or o.rgst_cap <> n.rgst_cap
        or o.rgst_cap_curr_cd <> n.rgst_cap_curr_cd
        or o.asset_tot <> n.asset_tot
        or o.leg_oper_situ <> n.leg_oper_situ
        or o.oper_field_area <> n.oper_field_area
        or o.major_prod_serv_situ <> n.major_prod_serv_situ
        or o.work_rg_dist_cd <> n.work_rg_dist_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,found_dt -- 成立日期
    ,rgst_cd -- 登记注册代码
    ,oper_field_prop_cd -- 经营场地所有权代码
    ,oper_range -- 经营范围
    ,corp_rgst_type_cd -- 企业登记注册类型代码
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,rgst_cap -- 注册资本
    ,rgst_cap_curr_cd -- 注册资本币种代码
    ,asset_tot -- 集团资产总额
    ,leg_oper_situ -- 合法经营情况
    ,oper_field_area -- 经营场地面积
    ,major_prod_serv_situ -- 主要产品和服务情况
    ,work_rg_dist_cd -- 办公地区行政区划代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,found_dt -- 成立日期
    ,rgst_cd -- 登记注册代码
    ,oper_field_prop_cd -- 经营场地所有权代码
    ,oper_range -- 经营范围
    ,corp_rgst_type_cd -- 企业登记注册类型代码
    ,paid_in_capital -- 实收资本
    ,paid_in_capital_curr_cd -- 实收资本币种代码
    ,invtor_cty_cd -- 投资方国家代码
    ,rgst_cap -- 注册资本
    ,rgst_cap_curr_cd -- 注册资本币种代码
    ,asset_tot -- 集团资产总额
    ,leg_oper_situ -- 合法经营情况
    ,oper_field_area -- 经营场地面积
    ,major_prod_serv_situ -- 主要产品和服务情况
    ,work_rg_dist_cd -- 办公地区行政区划代码
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
    ,o.found_dt -- 成立日期
    ,o.rgst_cd -- 登记注册代码
    ,o.oper_field_prop_cd -- 经营场地所有权代码
    ,o.oper_range -- 经营范围
    ,o.corp_rgst_type_cd -- 企业登记注册类型代码
    ,o.paid_in_capital -- 实收资本
    ,o.paid_in_capital_curr_cd -- 实收资本币种代码
    ,o.invtor_cty_cd -- 投资方国家代码
    ,o.rgst_cap -- 注册资本
    ,o.rgst_cap_curr_cd -- 注册资本币种代码
    ,o.asset_tot -- 集团资产总额
    ,o.leg_oper_situ -- 合法经营情况
    ,o.oper_field_area -- 经营场地面积
    ,o.major_prod_serv_situ -- 主要产品和服务情况
    ,o.work_rg_dist_cd -- 办公地区行政区划代码
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
from ${iml_schema}.pty_corp_rgst_info_h_eifsf1_bk o
    left join ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl d
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
--truncate table ${iml_schema}.pty_corp_rgst_info_h;
--alter table ${iml_schema}.pty_corp_rgst_info_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_corp_rgst_info_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_corp_rgst_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_corp_rgst_info_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_corp_rgst_info_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl;
alter table ${iml_schema}.pty_corp_rgst_info_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp_rgst_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_corp_rgst_info_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp_rgst_info_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
