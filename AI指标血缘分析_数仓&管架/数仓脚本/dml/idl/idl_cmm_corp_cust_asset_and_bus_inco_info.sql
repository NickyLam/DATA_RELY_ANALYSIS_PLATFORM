/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_corp_cust_asset_and_bus_inco_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info drop partition p_${last_date};
alter table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info (
    etl_dt  -- 数据日期   
    ,cust_id  -- 客户编号   
    ,cust_name  -- 客户名称   
    ,tot_asset  -- 总资产   
    ,bus_inco  -- 营业收入   
    ,etl_timestamp  -- 数据处理时间   
)
select to_date('${batch_date}', 'yyyymmdd') as etl_dt -- 数据日期
      ,khdm as cust_id -- 客户代码
      ,khmc as cust_name -- 客户名称
      ,decode(max(zzc), -9999999999999, '', max(zzc)) as tot_asset -- 总资产_元
      ,decode(max(yysr), -9999999999999, '', max(yysr)) as bus_inco -- 营业收入_元 
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 数据处理时间
  from (select t.enterprisename as khmc,
               t.mfcustomerid as khdm,
               case
                 when rd.rowsubject = '804' then
                  rd.col2value
                 else
                  -9999999999999
               end as zzc,
               case
                 when rd.rowsubject = '501' then
                  rd.col2value
                 else
                  -9999999999999
               end as yysr
          from iol.crss_report_record rr,
               iol.crss_report_data rd,
               (select cf.customerid,
                       ei.enterprisename,
                       ei.mfcustomerid,
                       cf.reportdate,
                       cf.reportscope,
                       cf.modelclass,
                       row_number() over(partition by cf.customerid order by reportdate desc) rn
                  from iol.crss_customer_fsrecord cf,
                       iol.crss_ent_info          ei,
                       iol.crss_customer_info     ci
                 where cf.customerid = ei.customerid
                   and cf.reportdate <= '${batch_date}'
                   and ei.customerid = ci.customerid
                   and ci.customertype like '01%'
                   and ci.mfcustomerid is not null
                   and cf.modelclass in ('029')
                   and cf.reportperiod = '04'
                   and (cf.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
                       cf.end_dt > to_date('${batch_date}', 'yyyymmdd'))
                   and (ei.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
                       ei.end_dt > to_date('${batch_date}', 'yyyymmdd'))
                   and (ci.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
                       ci.end_dt > to_date('${batch_date}', 'yyyymmdd'))) t
         where rr.reportno = rd.reportno
           and (rr.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
               rr.end_dt > to_date('${batch_date}', 'yyyymmdd'))
           and (rd.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
               rd.end_dt > to_date('${batch_date}', 'yyyymmdd'))
           and t.reportdate = rr.reportdate
           and t.reportscope = rr.reportscope
           and t.customerid = rr.objectno
           and rr.objecttype = 'CustomerFS'
           and t.rn = 1
           and (rd.rowsubject = '804' or rd.rowsubject = '501')
           and (exists
                (select 1
                   from iol.crss_business_approve ba
                  where ba.customerid = t.customerid
                    and (ba.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
                        ba.end_dt > to_date('${batch_date}', 'yyyymmdd'))
                    and ba.approvedate <> ' '
                    and ba.creditflowtype = ' '
                    and ba.businesstype like '3010%') or exists
                (select 1
                   from iol.crss_business_contract ba
                  where ba.customerid = t.customerid
                    and (ba.start_dt <= to_date('${batch_date}', 'yyyymmdd') and
                        ba.end_dt > to_date('${batch_date}', 'yyyymmdd'))
                    and ba.effectflag <> ' 00'
                    and ba.creditmode = '01'
                    and ba.creditflowtype = ' '
                    and ba.businesstype like '3010%')))
 group by khmc, khdm;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_corp_cust_asset_and_bus_inco_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);