/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_less_les_riskexp_detail
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.less_les_riskexp_detail_ex purge;
alter table ${iol_schema}.less_les_riskexp_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.less_les_riskexp_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.less_les_riskexp_detail_ex nologging
compress
as
select * from ${iol_schema}.less_les_riskexp_detail where 0=1;

insert /*+ append */ into ${iol_schema}.less_les_riskexp_detail_ex(
    datadate -- 数据日期
    ,srcsysid -- 源系统编号
    ,expseid -- 暴露编号
    ,relbusnsid -- 关联业务编号
    ,srccustomerid -- 源系统暴露主体编号
    ,srccustomername -- 源系统暴露主体名称
    ,collcertnum -- 归集证件号码
    ,collcustomername -- 归集暴露主体名称
    ,isbank -- 是否同业
    ,issupvsexptlistcust -- 是否监管豁免清单客户
    ,subjnum -- 科目号
    ,subjname -- 科目名称
    ,expsecls -- 暴露分类
    ,currency -- 币种
    ,bfriskexpse -- 缓释前风险暴露
    ,afriskexpse -- 缓释后风险暴露
    ,isbond -- 是否为债券
    ,anyloanbal -- 各项贷款余额
    ,balance -- 业务余额
    ,tdprodtype -- 特定产品类型（ProductType）
    ,srcorgid -- 源机构id
    ,srcorgname -- 源机构名称
    ,paratborgid -- 暴露业务并表机构编号
    ,isproduct -- 是否产品
    ,etltaskname -- etl作业名称
    ,etlupddate -- etl更新日期
    ,nonperformloanbal -- 不良贷款余额
    ,overdueloanbal -- 逾期贷款余额
    ,collrelacertnum -- 集团编号
    ,collrelacustomername -- 集团名称
    ,customertype -- 客户类型
    ,busnsbal -- 账面价值
    ,assetimpairment -- 减值
    ,balsum -- 业务余额
    ,marketval -- 市场价值
    ,collval -- 缓释
    ,duebillno -- 借据编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadate -- 数据日期
    ,srcsysid -- 源系统编号
    ,expseid -- 暴露编号
    ,relbusnsid -- 关联业务编号
    ,srccustomerid -- 源系统暴露主体编号
    ,srccustomername -- 源系统暴露主体名称
    ,collcertnum -- 归集证件号码
    ,collcustomername -- 归集暴露主体名称
    ,isbank -- 是否同业
    ,issupvsexptlistcust -- 是否监管豁免清单客户
    ,subjnum -- 科目号
    ,subjname -- 科目名称
    ,expsecls -- 暴露分类
    ,currency -- 币种
    ,bfriskexpse -- 缓释前风险暴露
    ,afriskexpse -- 缓释后风险暴露
    ,isbond -- 是否为债券
    ,anyloanbal -- 各项贷款余额
    ,balance -- 业务余额
    ,tdprodtype -- 特定产品类型（ProductType）
    ,srcorgid -- 源机构id
    ,srcorgname -- 源机构名称
    ,paratborgid -- 暴露业务并表机构编号
    ,isproduct -- 是否产品
    ,etltaskname -- etl作业名称
    ,etlupddate -- etl更新日期
    ,nonperformloanbal -- 不良贷款余额
    ,overdueloanbal -- 逾期贷款余额
    ,collrelacertnum -- 集团编号
    ,collrelacustomername -- 集团名称
    ,customertype -- 客户类型
    ,busnsbal -- 账面价值
    ,assetimpairment -- 减值
    ,balsum -- 业务余额
    ,marketval -- 市场价值
    ,collval -- 缓释
    ,duebillno -- 借据编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.less_les_riskexp_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.less_les_riskexp_detail exchange partition p_${batch_date} with table ${iol_schema}.less_les_riskexp_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.less_les_riskexp_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.less_les_riskexp_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'less_les_riskexp_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);