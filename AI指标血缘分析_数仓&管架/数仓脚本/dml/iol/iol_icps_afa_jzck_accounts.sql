/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icps_afa_jzck_accounts
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
drop table ${iol_schema}.icps_afa_jzck_accounts_ex purge;
alter table ${iol_schema}.icps_afa_jzck_accounts add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icps_afa_jzck_accounts truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icps_afa_jzck_accounts_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icps_afa_jzck_accounts where 0=1;

insert /*+ append */ into ${iol_schema}.icps_afa_jzck_accounts_ex(
    productcode -- 产品代号
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,txcode -- 交易类型编码
    ,transserialnumber -- 请求单号
    ,applicationid -- 任务流水号
    ,accountname -- 账户名称
    ,cardnumber -- 主账户
    ,accountnumber -- 卡号
    ,depositbankbranch -- 开户网点
    ,depositbankbranchcode -- 开户网点代码
    ,accountopentime -- 开户日期
    ,accountcancellationtime -- 销户日期
    ,accountcancellationbranch -- 销户网点
    ,accounttype -- 账户类型
    ,accountstatus -- 账户状态
    ,currency -- 币种
    ,cashremit -- 钞汇标志
    ,accountbalance -- 账户余额
    ,availablebalance -- 可用余额
    ,lasttransactiontime -- 最后交易时间
    ,remark -- 备注
    ,remark1 -- 备用字段1
    ,remark2 -- 欸用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,accountserial -- 账户序号
    ,yxq -- 有效期
    ,glzjzh -- 关联资金账户
    ,zhrmbye -- 折合人民币余额
    ,syblrq -- 银行卡签约时间
    ,qywd -- 银行卡签约网点
    ,syzzrq -- 银行卡终止签约时间
    ,zhdj -- 账号等级
    ,zcwblx -- 支持外币类型
    ,zhdlip -- 最后登录IP
    ,zhdlsj -- 最后登录时间
    ,wyzhmc -- 网银账户名称
    ,bankname -- 开户银行
    ,bankcode -- 开户银行代码
    ,khwdszd -- 开户网点所在地
    ,openbranchtel -- 开户网点电话
    ,yzbm -- 邮政编码
    ,shortname -- 开户银行英文简称
    ,txdz -- 开户人联系地址
    ,lxdh -- 开户人联系电话
    ,xhwddm -- 销户网点代码
    ,xhwdszd -- 销户网点所在地
    ,bksj -- 补卡时间
    ,bkwd -- 补卡网点
    ,bkwddm -- 补卡网点代码
    ,bkwdszd -- 补卡网点所在地
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,isfro -- 是否支持网上冻结
    ,sftz -- 是否透支
    ,datatype -- 数据类型
    ,cardstatus -- 卡状态
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    productcode -- 产品代号
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,txcode -- 交易类型编码
    ,transserialnumber -- 请求单号
    ,applicationid -- 任务流水号
    ,accountname -- 账户名称
    ,cardnumber -- 主账户
    ,accountnumber -- 卡号
    ,depositbankbranch -- 开户网点
    ,depositbankbranchcode -- 开户网点代码
    ,accountopentime -- 开户日期
    ,accountcancellationtime -- 销户日期
    ,accountcancellationbranch -- 销户网点
    ,accounttype -- 账户类型
    ,accountstatus -- 账户状态
    ,currency -- 币种
    ,cashremit -- 钞汇标志
    ,accountbalance -- 账户余额
    ,availablebalance -- 可用余额
    ,lasttransactiontime -- 最后交易时间
    ,remark -- 备注
    ,remark1 -- 备用字段1
    ,remark2 -- 欸用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,accountserial -- 账户序号
    ,yxq -- 有效期
    ,glzjzh -- 关联资金账户
    ,zhrmbye -- 折合人民币余额
    ,syblrq -- 银行卡签约时间
    ,qywd -- 银行卡签约网点
    ,syzzrq -- 银行卡终止签约时间
    ,zhdj -- 账号等级
    ,zcwblx -- 支持外币类型
    ,zhdlip -- 最后登录IP
    ,zhdlsj -- 最后登录时间
    ,wyzhmc -- 网银账户名称
    ,bankname -- 开户银行
    ,bankcode -- 开户银行代码
    ,khwdszd -- 开户网点所在地
    ,openbranchtel -- 开户网点电话
    ,yzbm -- 邮政编码
    ,shortname -- 开户银行英文简称
    ,txdz -- 开户人联系地址
    ,lxdh -- 开户人联系电话
    ,xhwddm -- 销户网点代码
    ,xhwdszd -- 销户网点所在地
    ,bksj -- 补卡时间
    ,bkwd -- 补卡网点
    ,bkwddm -- 补卡网点代码
    ,bkwdszd -- 补卡网点所在地
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,isfro -- 是否支持网上冻结
    ,sftz -- 是否透支
    ,datatype -- 数据类型
    ,cardstatus -- 卡状态
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icps_afa_jzck_accounts
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icps_afa_jzck_accounts exchange partition p_${batch_date} with table ${iol_schema}.icps_afa_jzck_accounts_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icps_afa_jzck_accounts to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icps_afa_jzck_accounts_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icps_afa_jzck_accounts',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);