/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wyd_lmt_h_icmsf1
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
drop table ${iml_schema}.agt_wyd_lmt_h_icmsf1_tm purge;
alter table ${iml_schema}.agt_wyd_lmt_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wyd_lmt_h modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_lmt_h_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,org_id -- 机构编号
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_id -- 授信编号
    ,crdt_dt -- 授信日期
    ,crdt_lmt -- 授信额度
    ,lmt_status_cd -- 额度状态代码
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,crdt_bus_type_cd -- 授信业务类型代码
    ,crdt_update_dt -- 授信更新日期
    ,froz_status_cd -- 冻结状态代码
    ,appl_lmt_adj_dt -- 申请额度调整日期
    ,lmt_adj_dt -- 额度调整日期
    ,cust_mgr_id -- 客户经理编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wyd_lmt_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_credit_line-1
insert into ${iml_schema}.agt_wyd_lmt_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,curr_cd -- 币种代码
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,org_id -- 机构编号
    ,crdt_id -- 循环额度标志
    ,circl_lmt_flg -- 授信编号
    ,crdt_dt -- 授信日期
    ,crdt_lmt -- 授信额度
    ,lmt_status_cd -- 额度状态代码
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,crdt_bus_type_cd -- 授信业务类型代码
    ,crdt_update_dt -- 授信更新日期
    ,froz_status_cd -- 冻结状态代码
    ,appl_lmt_adj_dt -- 申请额度调整日期
    ,lmt_adj_dt -- 额度调整日期
    ,cust_mgr_id -- 客户经理编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300063'||P1.LIMITNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LIMITNO -- 额度编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTNAME -- 客户名称
    ,nvl(trim(P1.CUSTIDTYPE),'0000') -- 证件类型代码
    ,P1.CUSTIDNO -- 证件号码
    ,nvl(trim(P1.CCYCD),'-') -- 币种代码
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,P1.ORGID -- 机构编号
    ,P1.BASERIALNO -- 循环额度标志
    ,decode(P1.CIRCULFLG,'N','0','Y','1',' ','-',P1.CIRCULFLG) -- 授信编号
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 授信日期
    ,P1.QUOTAMOD -- 授信额度
    ,nvl(trim(P1.BALSTATUS),'-') -- 额度状态代码
    ,${iml_schema}.dateformat_min(P1.INITDATE) -- 额度生效日期
    ,${iml_schema}.dateformat_max2(P1.MATURITYDATE) -- 额度失效日期
    ,nvl(trim(P1.CREDITTYPE),'-') -- 授信业务类型代码
    ,${iml_schema}.dateformat_min(P1.TRANDATE) -- 授信更新日期
    ,nvl(trim(P1.FREEZEFLAG),' ') -- 冻结状态代码
    ,${iml_schema}.dateformat_max2(regexp_replace(P1.ADJUSTDATE,'[^0-9.]','')) -- 申请额度调整日期
    ,${iml_schema}.dateformat_max2(regexp_replace(P1.EXTENDDATE,'[^0-9.]','')) -- 额度调整日期
    ,P1.INPUTID -- 客户经理编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_credit_line' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_credit_line p1
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_wyd_lmt_h truncate subpartition p_icmsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_wyd_lmt_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wyd_lmt_h_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wyd_lmt_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wyd_lmt_h_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wyd_lmt_h', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);