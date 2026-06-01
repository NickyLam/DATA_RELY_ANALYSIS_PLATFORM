/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_accr_detl
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
drop table ${iol_schema}.tgls_tax_accr_detl_ex purge;
alter table ${iol_schema}.tgls_tax_accr_detl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_tax_accr_detl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_tax_accr_detl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_accr_detl where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_tax_accr_detl_ex(
    stacid -- 账套
    ,deptcode -- 计提机构编号
    ,period -- 计提期间
    ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，10-车船税）
    ,taxdate -- 计提日期
    ,transq -- 流水号
    ,crcycd -- 币种代码
    ,isprep -- 是否预计提（1-预计提，0-税费计提）
    ,assecd -- 资产编号
    ,assena -- 资产名称
    ,itemcd -- 科目编号
    ,amntcd -- 借贷方向（c-贷，d-借）
    ,taxtype -- 税种类型（01-企业所得税，02-递延所得税）
    ,contrst -- 合同类型
    ,vatway -- 计税方式（0-从价计税，1-从租计税，2-从价从租计税）
    ,landgr -- 土地等级
    ,vatxrt -- 土地使用税额
    ,carstp -- 车船类型
    ,itemtp -- 项目类型（1-递延所得税资产，2-递延所得税负债）
    ,lsblam -- 资产期初税额
    ,asseam -- 资产发生税额
    ,assexm -- 资产发生金额
    ,yaseam -- 资产本年发生税额
    ,yasexm -- 资产本年发生金额
    ,onblam -- 资产期末税额
    ,txdpam -- 税法累计折旧税额
    ,cjfcam -- 房产从价税额
    ,czfcam -- 房产从租税额
    ,fromam -- 账面公式税额
    ,lmfmam -- 限额公式税额
    ,fromxm -- 账面公式金额
    ,lmfmxm -- 限额公式金额
    ,qualit -- 质量（吨）
    ,amount -- 数量
    ,tpprof -- 取值类型（am-发送额，bb-期初余额，eb-期末余额）
    ,zjflag -- 账面价值与计税基础比较（1：大于，2：小于）
    ,smrytx -- 备注
    ,creadt -- 资产录入vat系统时间
    ,commti -- 计提时间
    ,assis1 -- 辅助字段1
    ,assis2 -- 辅助字段2
    ,assis3 -- 辅助字段3
    ,assis4 -- 辅助字段4
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,deptcode -- 计提机构编号
    ,period -- 计提期间
    ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，10-车船税）
    ,taxdate -- 计提日期
    ,transq -- 流水号
    ,crcycd -- 币种代码
    ,isprep -- 是否预计提（1-预计提，0-税费计提）
    ,assecd -- 资产编号
    ,assena -- 资产名称
    ,itemcd -- 科目编号
    ,amntcd -- 借贷方向（c-贷，d-借）
    ,taxtype -- 税种类型（01-企业所得税，02-递延所得税）
    ,contrst -- 合同类型
    ,vatway -- 计税方式（0-从价计税，1-从租计税，2-从价从租计税）
    ,landgr -- 土地等级
    ,vatxrt -- 土地使用税额
    ,carstp -- 车船类型
    ,itemtp -- 项目类型（1-递延所得税资产，2-递延所得税负债）
    ,lsblam -- 资产期初税额
    ,asseam -- 资产发生税额
    ,assexm -- 资产发生金额
    ,yaseam -- 资产本年发生税额
    ,yasexm -- 资产本年发生金额
    ,onblam -- 资产期末税额
    ,txdpam -- 税法累计折旧税额
    ,cjfcam -- 房产从价税额
    ,czfcam -- 房产从租税额
    ,fromam -- 账面公式税额
    ,lmfmam -- 限额公式税额
    ,fromxm -- 账面公式金额
    ,lmfmxm -- 限额公式金额
    ,qualit -- 质量（吨）
    ,amount -- 数量
    ,tpprof -- 取值类型（am-发送额，bb-期初余额，eb-期末余额）
    ,zjflag -- 账面价值与计税基础比较（1：大于，2：小于）
    ,smrytx -- 备注
    ,creadt -- 资产录入vat系统时间
    ,commti -- 计提时间
    ,assis1 -- 辅助字段1
    ,assis2 -- 辅助字段2
    ,assis3 -- 辅助字段3
    ,assis4 -- 辅助字段4
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_tax_accr_detl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_tax_accr_detl exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_accr_detl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_accr_detl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_tax_accr_detl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_accr_detl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);