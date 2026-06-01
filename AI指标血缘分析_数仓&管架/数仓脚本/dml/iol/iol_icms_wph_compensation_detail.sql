/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_compensation_detail
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
drop table ${iol_schema}.icms_wph_compensation_detail_ex purge;
alter table ${iol_schema}.icms_wph_compensation_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wph_compensation_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wph_compensation_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_compensation_detail where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wph_compensation_detail_ex(
    trandate -- 交易日期
    ,receiptno -- 回收号
    ,internalkey -- 借据号
    ,prodtype -- 产品类型
    ,compstageno -- 本次代偿期数
    ,ccy -- 币种
    ,compamtpartner -- 本次代偿总额_资金方
    ,comppriamtpartner -- 本次代偿本金_资金方
    ,compintamtpartner -- 本次代偿利息_资金方
    ,compodpamtpartner -- 本次代偿罚息_资金方
    ,compodiamtpartner -- 本次代偿复利_资金方
    ,compamtwpfb -- 本次代偿总额_唯品富邦
    ,comppriamtwpfb -- 本次代偿本金_唯品富邦
    ,compintamtwpfb -- 本次代偿利息_唯品富邦
    ,compodpamtwpfb -- 本次代偿罚息_唯品富邦
    ,compodiamtwpfb -- 本次代偿复利_唯品富邦
    ,paydate -- 应还款日期
    ,actrepaydate -- 实际还款日期
    ,ovedate -- 逾期天数
    ,compdate -- 代偿日期
    ,unionguaranteeflag -- 融担模式
    ,guaranteeaid -- 担保方ID1
    ,guaranteearate -- 担保方1担保比例
    ,guaranteeaamtpartner -- 担保方1代偿总额_资金方
    ,guaranteeapriamtpartner -- 担保方1代偿本金_资金方
    ,guaranteeaintamtpartner -- 担保方1代偿利息_资金方
    ,guaranteeaodpamtpartner -- 担保方1代偿罚息_资金方
    ,guaranteeaodiamtpartner -- 担保方1代偿复利_资金方
    ,guaranteeaamtwpfb -- 担保方1代偿总额_唯品富邦
    ,guaranteeapriamtwpfb -- 担保方1代偿本金_唯品富邦
    ,guaranteeaintamtwpfb -- 担保方1代偿利息_唯品富邦
    ,guaranteeaodpamtwpfb -- 担保方1代偿罚息_唯品富邦
    ,guaranteeaodiamtwpfb -- 担保方1代偿复利_唯品富邦
    ,guaranteebid -- 担保方ID2
    ,guaranteebrate -- 担保方2担保比例
    ,guaranteebamtpartner -- 担保方2代偿总额_资金方
    ,guaranteebpriamtpartner -- 担保方2代偿本金_资金方
    ,guaranteebintamtpartner -- 担保方2代偿利息_资金方
    ,guaranteebodpamtpartner -- 担保方2代偿罚息_资金方
    ,guaranteebodiamtpartner -- 担保方2代偿复利_资金方
    ,guaranteebamtwpfb -- 担保方2代偿总额_唯品富邦
    ,guaranteebpriamtwpfb -- 担保方2代偿本金_唯品富邦
    ,guaranteebintamtwpfb -- 担保方2代偿利息_唯品富邦
    ,guaranteebodpamtwpfb -- 担保方2代偿罚息_唯品富邦
    ,guaranteebodiamtwpfb -- 担保方2代偿复利_唯品富邦
    ,inputdate -- 登记日期
    ,bizdate -- 流程日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trandate -- 交易日期
    ,receiptno -- 回收号
    ,internalkey -- 借据号
    ,prodtype -- 产品类型
    ,compstageno -- 本次代偿期数
    ,ccy -- 币种
    ,compamtpartner -- 本次代偿总额_资金方
    ,comppriamtpartner -- 本次代偿本金_资金方
    ,compintamtpartner -- 本次代偿利息_资金方
    ,compodpamtpartner -- 本次代偿罚息_资金方
    ,compodiamtpartner -- 本次代偿复利_资金方
    ,compamtwpfb -- 本次代偿总额_唯品富邦
    ,comppriamtwpfb -- 本次代偿本金_唯品富邦
    ,compintamtwpfb -- 本次代偿利息_唯品富邦
    ,compodpamtwpfb -- 本次代偿罚息_唯品富邦
    ,compodiamtwpfb -- 本次代偿复利_唯品富邦
    ,paydate -- 应还款日期
    ,actrepaydate -- 实际还款日期
    ,ovedate -- 逾期天数
    ,compdate -- 代偿日期
    ,unionguaranteeflag -- 融担模式
    ,guaranteeaid -- 担保方ID1
    ,guaranteearate -- 担保方1担保比例
    ,guaranteeaamtpartner -- 担保方1代偿总额_资金方
    ,guaranteeapriamtpartner -- 担保方1代偿本金_资金方
    ,guaranteeaintamtpartner -- 担保方1代偿利息_资金方
    ,guaranteeaodpamtpartner -- 担保方1代偿罚息_资金方
    ,guaranteeaodiamtpartner -- 担保方1代偿复利_资金方
    ,guaranteeaamtwpfb -- 担保方1代偿总额_唯品富邦
    ,guaranteeapriamtwpfb -- 担保方1代偿本金_唯品富邦
    ,guaranteeaintamtwpfb -- 担保方1代偿利息_唯品富邦
    ,guaranteeaodpamtwpfb -- 担保方1代偿罚息_唯品富邦
    ,guaranteeaodiamtwpfb -- 担保方1代偿复利_唯品富邦
    ,guaranteebid -- 担保方ID2
    ,guaranteebrate -- 担保方2担保比例
    ,guaranteebamtpartner -- 担保方2代偿总额_资金方
    ,guaranteebpriamtpartner -- 担保方2代偿本金_资金方
    ,guaranteebintamtpartner -- 担保方2代偿利息_资金方
    ,guaranteebodpamtpartner -- 担保方2代偿罚息_资金方
    ,guaranteebodiamtpartner -- 担保方2代偿复利_资金方
    ,guaranteebamtwpfb -- 担保方2代偿总额_唯品富邦
    ,guaranteebpriamtwpfb -- 担保方2代偿本金_唯品富邦
    ,guaranteebintamtwpfb -- 担保方2代偿利息_唯品富邦
    ,guaranteebodpamtwpfb -- 担保方2代偿罚息_唯品富邦
    ,guaranteebodiamtwpfb -- 担保方2代偿复利_唯品富邦
    ,inputdate -- 登记日期
    ,bizdate -- 流程日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wph_compensation_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wph_compensation_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_compensation_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_compensation_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wph_compensation_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_compensation_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);