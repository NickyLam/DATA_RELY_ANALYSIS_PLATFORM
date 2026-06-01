/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_customer_info
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
drop table ${iol_schema}.icms_wyd_customer_info_ex purge;
alter table ${iol_schema}.icms_wyd_customer_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_customer_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_customer_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_customer_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_customer_info_ex(
    customerid -- 客户号
    ,financialorganizationnumber -- 客户类别
    ,customertype -- 客户类型
    ,customersubtype -- 客户子类型
    ,enterprisename -- 客户中文名称
    ,certtype -- 主证件类型
    ,certid -- 证件号码
    ,certidexpiredate -- 证件到期日
    ,institutionalcreditcode -- 统一社会信用代码
    ,organizationcertificatenumber -- 营业执照号
    ,expiredate -- 营业执照有效截止日期
    ,registeraddr -- 注册地址
    ,registercountry -- 国别
    ,registerareacode -- 行政区划代码
    ,registerareaname -- 行政区划名称
    ,registerdate -- 成立日期
    ,operatinglife -- 经营年限
    ,acoperatinglife -- 实际控制人从业年限
    ,mostbusiness -- 经营范围
    ,rccurrency -- 注册资本币种
    ,pccurrency -- 注册资本（元）
    ,industrytype -- 行业投向
    ,economicindustrytype -- 经济行业分类
    ,economictype -- 经济类型
    ,officetel -- 办公联系电话
    ,financedepttel -- 财务联系电话
    ,owebalancesumbalance -- 欠息汇总-余额
    ,badsumbalance -- 不良、违约类汇总（余额）
    ,riskwarning -- 风险预警信号
    ,basicaccoutcode -- 基本存款账号
    ,basicaccoutname -- 基本账户开户行名称
    ,listingflag -- 上市公司标志
    ,zipcode -- 邮政编码
    ,phonenumber -- 传真号码
    ,staffnumber -- 员工人数
    ,enterpriseholdingtype -- 企业控股类型
    ,opencloseflag -- 是否关停企业
    ,organizationscale -- 企业规模
    ,inoutflag -- 境内境外标志
    ,laborintensiveflag -- 劳动密集型企业标志
    ,taxpayertype -- 纳税人类型
    ,recommend -- 推荐人
    ,taxpayerid -- 纳税人识别号
    ,creditrate -- 纳税等级
    ,portal -- 营销渠道号
    ,loansplitresult -- 客户是否分流
    ,orgminputoutdate -- 最早放款日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,custid -- 我行客户号
    ,updatedate1 -- 微纵更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    customerid -- 客户号
    ,financialorganizationnumber -- 客户类别
    ,customertype -- 客户类型
    ,customersubtype -- 客户子类型
    ,enterprisename -- 客户中文名称
    ,certtype -- 主证件类型
    ,certid -- 证件号码
    ,certidexpiredate -- 证件到期日
    ,institutionalcreditcode -- 统一社会信用代码
    ,organizationcertificatenumber -- 营业执照号
    ,expiredate -- 营业执照有效截止日期
    ,registeraddr -- 注册地址
    ,registercountry -- 国别
    ,registerareacode -- 行政区划代码
    ,registerareaname -- 行政区划名称
    ,registerdate -- 成立日期
    ,operatinglife -- 经营年限
    ,acoperatinglife -- 实际控制人从业年限
    ,mostbusiness -- 经营范围
    ,rccurrency -- 注册资本币种
    ,pccurrency -- 注册资本（元）
    ,industrytype -- 行业投向
    ,economicindustrytype -- 经济行业分类
    ,economictype -- 经济类型
    ,officetel -- 办公联系电话
    ,financedepttel -- 财务联系电话
    ,owebalancesumbalance -- 欠息汇总-余额
    ,badsumbalance -- 不良、违约类汇总（余额）
    ,riskwarning -- 风险预警信号
    ,basicaccoutcode -- 基本存款账号
    ,basicaccoutname -- 基本账户开户行名称
    ,listingflag -- 上市公司标志
    ,zipcode -- 邮政编码
    ,phonenumber -- 传真号码
    ,staffnumber -- 员工人数
    ,enterpriseholdingtype -- 企业控股类型
    ,opencloseflag -- 是否关停企业
    ,organizationscale -- 企业规模
    ,inoutflag -- 境内境外标志
    ,laborintensiveflag -- 劳动密集型企业标志
    ,taxpayertype -- 纳税人类型
    ,recommend -- 推荐人
    ,taxpayerid -- 纳税人识别号
    ,creditrate -- 纳税等级
    ,portal -- 营销渠道号
    ,loansplitresult -- 客户是否分流
    ,orgminputoutdate -- 最早放款日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,custid -- 我行客户号
    ,updatedate1 -- 微纵更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_customer_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_customer_info exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_customer_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_customer_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_customer_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_customer_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);