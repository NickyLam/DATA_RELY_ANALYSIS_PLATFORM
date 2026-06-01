/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_pass_bus_base_asset_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_tm purge;
drop table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_pass_bus_base_asset add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_pass_bus_base_asset modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pass_bus_base_asset partition for ('icmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_local_indus_cd -- 客户所在行业代码
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,cash_cust_type_cd -- 兑付方客户类型代码
    ,book_val -- 账面价值
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pass_bus_base_asset
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_pass_bus_base_asset partition for ('icmsf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_baseasset_info-1
insert into ${iml_schema}.agt_pass_bus_base_asset_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_local_indus_cd -- 客户所在行业代码
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,cash_cust_type_cd -- 兑付方客户类型代码
    ,book_val -- 账面价值
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231035'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 基础资产编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,NVL(TRIM(P1.INDUSTRY),'-') -- 客户所在行业代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.BUSINESSSUM -- 金额
    ,${iml_schema}.dateformat_min(TRIM(P1.BEGINDATE)) -- 起始日期
    ,${iml_schema}.dateformat_max2(TRIM(P1.ENDDATE)) -- 到期日期
    ,NVL(TRIM(P1.PAYCUSTOMERTYPE),'-') -- 兑付方客户类型代码
    ,P1.BOOKVALUE -- 账面价值
    ,P1.inputOrgId -- 登记机构编号
    ,P1.inputUserId -- 登记柜员编号
    ,P1.inputDate -- 登记日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_baseasset_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_baseasset_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_pass_bus_base_asset_icmsf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_pass_bus_base_asset_icmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,base_asset_id -- 基础资产编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cust_local_indus_cd -- 客户所在行业代码
    ,curr_cd -- 币种代码
    ,amt -- 金额
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,cash_cust_type_cd -- 兑付方客户类型代码
    ,book_val -- 账面价值
    ,rgst_org_id -- 登记机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_dt -- 登记日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.base_asset_id, o.base_asset_id) as base_asset_id -- 基础资产编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cust_local_indus_cd, o.cust_local_indus_cd) as cust_local_indus_cd -- 客户所在行业代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.cash_cust_type_cd, o.cash_cust_type_cd) as cash_cust_type_cd -- 兑付方客户类型代码
    ,nvl(n.book_val, o.book_val) as book_val -- 账面价值
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.base_asset_id <> n.base_asset_id
                or o.cust_id <> n.cust_id
                or o.cust_name <> n.cust_name
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.cust_local_indus_cd <> n.cust_local_indus_cd
                or o.curr_cd <> n.curr_cd
                or o.amt <> n.amt
                or o.begin_dt <> n.begin_dt
                or o.exp_dt <> n.exp_dt
                or o.cash_cust_type_cd <> n.cash_cust_type_cd
                or o.book_val <> n.book_val
                or o.rgst_org_id <> n.rgst_org_id
                or o.rgst_teller_id <> n.rgst_teller_id
                or o.rgst_dt <> n.rgst_dt
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pass_bus_base_asset_icmsf1_tm n
    full join ${iml_schema}.agt_pass_bus_base_asset_icmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_pass_bus_base_asset truncate partition for ('icmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_pass_bus_base_asset exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_pass_bus_base_asset drop subpartition p_icmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_pass_bus_base_asset to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_tm purge;
drop table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_ex purge;
drop table ${iml_schema}.agt_pass_bus_base_asset_icmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_pass_bus_base_asset', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);