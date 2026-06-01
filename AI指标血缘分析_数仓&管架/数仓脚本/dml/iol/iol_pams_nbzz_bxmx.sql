/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_nbzz_bxmx
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
drop table ${iol_schema}.pams_nbzz_bxmx_ex purge;
alter table ${iol_schema}.pams_nbzz_bxmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_nbzz_bxmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_nbzz_bxmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_nbzz_bxmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_nbzz_bxmx_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khh -- 客户号
    ,jgdh -- 机构代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zlbl -- 增量比例
    ,bf -- 保费
    ,zs -- 中收
    ,jyzhdh -- 账号代号
    ,cph -- 产品号
    ,bxdbh -- 保险单编号
    ,xybh -- 签约协议编号
    ,frbh -- 法人编号
    ,tadm -- TA代码
    ,hydh -- 行员代号
    ,gydh -- 柜员工号
    ,jyrq -- 交易日期
    ,bdrq -- 保单日期
    ,bdsxrq -- 保单生效日期
    ,bxdqrq -- 保险到期日期
    ,tbrmc -- 投保人名称
    ,tbrzjhm -- 投保人证件号码
    ,bxgsmc -- 保险公司名称
    ,xzlx -- 险种类型
    ,zxmc -- 险种名称
    ,tbxz -- 投保险种
    ,bbxrmc -- 被保险人名称
    ,bbxrzjhm -- 被保险人证件号码
    ,jffs -- 缴费方式
    ,jfnqdw -- 缴费年期单位
    ,bxqxdw -- 保险期限单位
    ,jfnq -- 缴费年期
    ,bxqx -- 保险期限
    ,jyqd -- 交易渠道
    ,bdzt -- 保单状态
    ,tbrq -- 投保日期
    ,zhye -- 账户余额
    ,dlsxfl -- 代理手续费率
    ,dlsxf -- 代理手续费
    ,qs -- 取数
    ,fphzhye -- 分配后余额
    ,fphsxf -- 分配后手续费
    ,nlj -- 年累计
    ,jlj -- 季累计
    ,ylj -- 月累计余额
    ,nrj -- 年日均
    ,jrj -- 季日均
    ,yrj -- 月日均
    ,ncye -- 年初余额
    ,jcye -- 季初余额
    ,ycye -- 月初余额
    ,dqye -- 当期余额
    ,sxfnlj -- 手续费年累计
    ,sxfjlj -- 手续费季累计
    ,sxfylj -- 手续费月累计
    ,bxgmbf -- 规模保费
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khh -- 客户号
    ,jgdh -- 机构代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zlbl -- 增量比例
    ,bf -- 保费
    ,zs -- 中收
    ,jyzhdh -- 账号代号
    ,cph -- 产品号
    ,bxdbh -- 保险单编号
    ,xybh -- 签约协议编号
    ,frbh -- 法人编号
    ,tadm -- TA代码
    ,hydh -- 行员代号
    ,gydh -- 柜员工号
    ,jyrq -- 交易日期
    ,bdrq -- 保单日期
    ,bdsxrq -- 保单生效日期
    ,bxdqrq -- 保险到期日期
    ,tbrmc -- 投保人名称
    ,tbrzjhm -- 投保人证件号码
    ,bxgsmc -- 保险公司名称
    ,xzlx -- 险种类型
    ,zxmc -- 险种名称
    ,tbxz -- 投保险种
    ,bbxrmc -- 被保险人名称
    ,bbxrzjhm -- 被保险人证件号码
    ,jffs -- 缴费方式
    ,jfnqdw -- 缴费年期单位
    ,bxqxdw -- 保险期限单位
    ,jfnq -- 缴费年期
    ,bxqx -- 保险期限
    ,jyqd -- 交易渠道
    ,bdzt -- 保单状态
    ,tbrq -- 投保日期
    ,zhye -- 账户余额
    ,dlsxfl -- 代理手续费率
    ,dlsxf -- 代理手续费
    ,qs -- 取数
    ,fphzhye -- 分配后余额
    ,fphsxf -- 分配后手续费
    ,nlj -- 年累计
    ,jlj -- 季累计
    ,ylj -- 月累计余额
    ,nrj -- 年日均
    ,jrj -- 季日均
    ,yrj -- 月日均
    ,ncye -- 年初余额
    ,jcye -- 季初余额
    ,ycye -- 月初余额
    ,dqye -- 当期余额
    ,sxfnlj -- 手续费年累计
    ,sxfjlj -- 手续费季累计
    ,sxfylj -- 手续费月累计
    ,bxgmbf -- 规模保费
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_nbzz_bxmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_nbzz_bxmx exchange partition p_${batch_date} with table ${iol_schema}.pams_nbzz_bxmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_nbzz_bxmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_nbzz_bxmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_nbzz_bxmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);