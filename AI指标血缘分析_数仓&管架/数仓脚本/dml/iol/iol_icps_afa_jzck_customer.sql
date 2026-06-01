/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icps_afa_jzck_customer
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
drop table ${iol_schema}.icps_afa_jzck_customer_ex purge;
alter table ${iol_schema}.icps_afa_jzck_customer add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icps_afa_jzck_customer truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icps_afa_jzck_customer_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icps_afa_jzck_customer where 0=1;

insert /*+ append */ into ${iol_schema}.icps_afa_jzck_customer_ex(
    productcode -- 产品代码详见产品代码数据字典
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,transserialnumber -- 传输报文流水号
    ,applicationid -- 业务申请编号
    ,result -- 查询反馈结果对该查询任务的查询结果描述，成功或失败；01表示成功，02表示失败；
    ,description -- 查询反馈结果原因对该查询反馈结果的原因的描述；
    ,idtype -- 证照类型代码沿用请求单的证件类型代码；
    ,idnumber -- 证照号码沿用请求单的证件号码；
    ,accountname -- 客户名称客户的名称，沿用请求单的查询主体名称；
    ,telephone -- 联系电话客户联系电话；
    ,mobilephone -- 联系手机客户联系手机号码；
    ,operatorname -- 代办人姓名代办人的姓名；
    ,operatorcredentialtype -- 代办人证件类型代办人的证件类型，参见附录1证件类型代码规范；
    ,operatorcredentialnumber -- 代办人证件号码代办人的证件号码；
    ,residentaddress -- 住宅地址客户的住宅地址，属于个人账户开户信息；
    ,residenttelnumber -- 住宅电话客户的住宅电话，属于个人账户开户信息；
    ,workcompanyname -- 工作单位客户的工作单位，属于个人账户开户信息；
    ,workaddress -- 单位地址客户的单位地址，属于个人账户开户信息；
    ,worktelnumber -- 单位电话客户的单位电话，属于个人账户开户信息；
    ,emailaddress -- 邮箱地址客户的邮箱地址，属于个人账户开户信息；
    ,legalpersonrep -- 法人代表对公账户的法人代表，属于对公账户开户信息；
    ,legalpersonrepcredentialtype -- 法人代表证件类型对公账户的法人代表证件类型，属于对公账户开户信息；
    ,legalpersonrepcredentialnumber -- 法人代表证件号码对公账户的法人代表证件号码，属于对公账户开户信息；
    ,businesslicensenumber -- 客户工商执照号码对公账户的客户工商执照号码，属于对公账户开户信息；
    ,statetaxserial -- 国税纳税号对公账户的企业国税纳税号，属于对公账户开户信息；
    ,localtaxserial -- 地税纳税号对公账户的企业地税纳税号，属于对公账户开户信息；
    ,remark1 -- 备用字段1
    ,remark2 -- 备用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,zddz -- 账单地址
    ,dbrlxdh -- 代办人联系电话
    ,sjyhblrq -- 手机银行办理日期
    ,sjyhkhwd -- 手机银行开户网点
    ,sjyhkhwddm -- 手机银行开户网点代码
    ,sjyhkhwdszd -- 手机银行开户网点所在地
    ,sjyhzhm -- 手机银行账户名
    ,wyblrq -- 网银办理日期
    ,wykhwd -- 网银开户网点
    ,wykhwddm -- 网银开户网点代码
    ,wykhwdszd -- 网银开户网点所在地
    ,wyzhm -- 网银账户名
    ,custno -- 客户号
    ,addr -- 联系地址
    ,credentialexpirydate -- 证照失效日期
    ,postcode -- 邮政编码
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    productcode -- 产品代码详见产品代码数据字典
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,transserialnumber -- 传输报文流水号
    ,applicationid -- 业务申请编号
    ,result -- 查询反馈结果对该查询任务的查询结果描述，成功或失败；01表示成功，02表示失败；
    ,description -- 查询反馈结果原因对该查询反馈结果的原因的描述；
    ,idtype -- 证照类型代码沿用请求单的证件类型代码；
    ,idnumber -- 证照号码沿用请求单的证件号码；
    ,accountname -- 客户名称客户的名称，沿用请求单的查询主体名称；
    ,telephone -- 联系电话客户联系电话；
    ,mobilephone -- 联系手机客户联系手机号码；
    ,operatorname -- 代办人姓名代办人的姓名；
    ,operatorcredentialtype -- 代办人证件类型代办人的证件类型，参见附录1证件类型代码规范；
    ,operatorcredentialnumber -- 代办人证件号码代办人的证件号码；
    ,residentaddress -- 住宅地址客户的住宅地址，属于个人账户开户信息；
    ,residenttelnumber -- 住宅电话客户的住宅电话，属于个人账户开户信息；
    ,workcompanyname -- 工作单位客户的工作单位，属于个人账户开户信息；
    ,workaddress -- 单位地址客户的单位地址，属于个人账户开户信息；
    ,worktelnumber -- 单位电话客户的单位电话，属于个人账户开户信息；
    ,emailaddress -- 邮箱地址客户的邮箱地址，属于个人账户开户信息；
    ,legalpersonrep -- 法人代表对公账户的法人代表，属于对公账户开户信息；
    ,legalpersonrepcredentialtype -- 法人代表证件类型对公账户的法人代表证件类型，属于对公账户开户信息；
    ,legalpersonrepcredentialnumber -- 法人代表证件号码对公账户的法人代表证件号码，属于对公账户开户信息；
    ,businesslicensenumber -- 客户工商执照号码对公账户的客户工商执照号码，属于对公账户开户信息；
    ,statetaxserial -- 国税纳税号对公账户的企业国税纳税号，属于对公账户开户信息；
    ,localtaxserial -- 地税纳税号对公账户的企业地税纳税号，属于对公账户开户信息；
    ,remark1 -- 备用字段1
    ,remark2 -- 备用字段2
    ,remark3 -- 备用字段3
    ,remark4 -- 备用字段4
    ,zddz -- 账单地址
    ,dbrlxdh -- 代办人联系电话
    ,sjyhblrq -- 手机银行办理日期
    ,sjyhkhwd -- 手机银行开户网点
    ,sjyhkhwddm -- 手机银行开户网点代码
    ,sjyhkhwdszd -- 手机银行开户网点所在地
    ,sjyhzhm -- 手机银行账户名
    ,wyblrq -- 网银办理日期
    ,wykhwd -- 网银开户网点
    ,wykhwddm -- 网银开户网点代码
    ,wykhwdszd -- 网银开户网点所在地
    ,wyzhm -- 网银账户名
    ,custno -- 客户号
    ,addr -- 联系地址
    ,credentialexpirydate -- 证照失效日期
    ,postcode -- 邮政编码
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icps_afa_jzck_customer
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icps_afa_jzck_customer exchange partition p_${batch_date} with table ${iol_schema}.icps_afa_jzck_customer_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icps_afa_jzck_customer to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icps_afa_jzck_customer_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icps_afa_jzck_customer',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);