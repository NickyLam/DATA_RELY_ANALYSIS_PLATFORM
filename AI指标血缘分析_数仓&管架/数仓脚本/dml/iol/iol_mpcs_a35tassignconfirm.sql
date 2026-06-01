/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a35tassignconfirm
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
drop table ${iol_schema}.mpcs_a35tassignconfirm_ex purge;
alter table ${iol_schema}.mpcs_a35tassignconfirm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a35tassignconfirm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a35tassignconfirm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a35tassignconfirm where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a35tassignconfirm_ex(
    cobank -- 合作银行 (0-平安  1-交行)
    ,custname -- 客户名称
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,acctno -- 结算账号
    ,pswd -- 结算账号密码
    ,seccd -- 券商代码
    ,secname -- 券商名称
    ,capitalacctno -- 证券资金台账号
    ,capitalpswd -- 券商证券资金密码
    ,ccy -- 币种
    ,custmanagerid -- 客户经理号
    ,custtype -- 客户类型 (00：机构 01：个人 默认“个人”)
    ,openbrcno -- 开户机构 (4位的合作行机构编号)
    ,sex -- 性别(0-男 1-女)
    ,secbrcno -- 券商营业部编号
    ,tycustno -- 同业客户号
    ,tyacctno -- 同业结算账号
    ,signtm -- 预指定确定时间 (统计月开户数)
    ,brcno -- 机构号
    ,brcname -- 机构名称
    ,confirmstatus -- 签约状态
    ,rspmsg -- 签约响应信息
    ,bizagtname -- 经办人姓名
    ,bizagtidtype -- 经办人证件类型
    ,bizagtidno -- 经办人证件号码
    ,custno -- 客户号
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,issign -- 是否签署(0-否，1-是)
    ,treaty_version -- 签约协议书的版本号
    ,argue_dealway -- 争议选择解决方式(01-深圳国际仲裁院,02-平安所在人民法院)
    ,treaty_source -- 签约协议来源(00-待签署,02-手机银行,03-个人网银,04-柜面,05-其他)
    ,signdate -- 签署协议时间
    ,signseqno -- 签署流水号
    ,sign_source -- 三方存管签约来源(0-未知，1-柜面，2-其他第三方)
    ,sign_ip -- 签署IP
    ,sign_mac -- 签署MAC地址
    ,sign_type -- 电脑或手机型号
    ,reserve4 -- 备用字段4
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cobank -- 合作银行 (0-平安  1-交行)
    ,custname -- 客户名称
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,acctno -- 结算账号
    ,pswd -- 结算账号密码
    ,seccd -- 券商代码
    ,secname -- 券商名称
    ,capitalacctno -- 证券资金台账号
    ,capitalpswd -- 券商证券资金密码
    ,ccy -- 币种
    ,custmanagerid -- 客户经理号
    ,custtype -- 客户类型 (00：机构 01：个人 默认“个人”)
    ,openbrcno -- 开户机构 (4位的合作行机构编号)
    ,sex -- 性别(0-男 1-女)
    ,secbrcno -- 券商营业部编号
    ,tycustno -- 同业客户号
    ,tyacctno -- 同业结算账号
    ,signtm -- 预指定确定时间 (统计月开户数)
    ,brcno -- 机构号
    ,brcname -- 机构名称
    ,confirmstatus -- 签约状态
    ,rspmsg -- 签约响应信息
    ,bizagtname -- 经办人姓名
    ,bizagtidtype -- 经办人证件类型
    ,bizagtidno -- 经办人证件号码
    ,custno -- 客户号
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,issign -- 是否签署(0-否，1-是)
    ,treaty_version -- 签约协议书的版本号
    ,argue_dealway -- 争议选择解决方式(01-深圳国际仲裁院,02-平安所在人民法院)
    ,treaty_source -- 签约协议来源(00-待签署,02-手机银行,03-个人网银,04-柜面,05-其他)
    ,signdate -- 签署协议时间
    ,signseqno -- 签署流水号
    ,sign_source -- 三方存管签约来源(0-未知，1-柜面，2-其他第三方)
    ,sign_ip -- 签署IP
    ,sign_mac -- 签署MAC地址
    ,sign_type -- 电脑或手机型号
    ,reserve4 -- 备用字段4
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a35tassignconfirm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a35tassignconfirm exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a35tassignconfirm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a35tassignconfirm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a35tassignconfirm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a35tassignconfirm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);