/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_putout_apply
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
drop table ${iol_schema}.icms_wyd_putout_apply_ex purge;
alter table ${iol_schema}.icms_wyd_putout_apply add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_putout_apply truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_putout_apply_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_putout_apply where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_putout_apply_ex(
    serialno -- 信贷唯一主键约束
    ,brno -- 合作机构号
    ,seqno -- 流水号
    ,corpname -- 企业全称
    ,regarea -- 注册国家或地区
    ,regadmarea -- 注册地行政区划
    ,regaddress -- 注册地址
    ,province -- 省份
    ,orgcode -- 组织机构代码
    ,regtype -- 注册或登记证件类型
    ,regnumber -- 注册或登记证件号码
    ,taxnumber -- 税务登记证号码
    ,socialunifiedcreditcode -- 社会统一信用代码
    ,category -- 国标行业分类
    ,busscale -- 企业规模代码
    ,smallcorpiden -- 银监会小企业标识
    ,custname -- 法人名称
    ,idtype -- 证件类型代码
    ,idno -- 证件编号
    ,sex -- 性别代码
    ,nationality -- 国籍代码
    ,career -- 职业代码
    ,birth -- 出生日
    ,telno -- 联系电话号码
    ,phoneno -- 手机号码
    ,pactamt -- 贷款合同金额
    ,lnrate -- 利率（年）
    ,apparea -- 申请地点
    ,appuse -- 申请用途
    ,termmon -- 合同期限（月）
    ,voutype -- 担保方式代码
    ,enddate -- 到期日
    ,paytype -- 扣款日类型
    ,payday -- 扣款日期
    ,merchantno -- 商户号
    ,busilicenseid -- 营业执照号
    ,busilicenseexpiredate -- 营业执照有效截止日期
    ,registerdate -- 成立日期
    ,operatinglife -- 经营年限
    ,staffnumber -- 员工人数
    ,needrefuse -- 需要拒绝
    ,legalbankcard -- 银行卡号
    ,legalmobile -- 手机号码
    ,quotamod -- 模型核额额度
    ,custlevel -- 内部评级
    ,loannum -- 贷款笔数
    ,enterprisecerttype -- 企业证件类型
    ,enterprisecertendtime -- 企业证件到期日
    ,custid -- ECIF客户号
    ,signingenpauthtime -- 企业征信授权书签署时间
    ,signingpersonauthtime -- 个人征信授权书签署时间
    ,signingenpauthseq -- 企业征信授权书签署流水号
    ,signingpersonauthseq -- 个人征信授权书签署流水号
    ,loantype -- 贷款形式
    ,loanacctno -- 原借据号
    ,guarantytype -- 是否银担业务
    ,guarantyorgname -- 担保公司名称
    ,guarantycerttype -- 担保公司证件类型
    ,guarantycertno -- 担保公司证件号码
    ,guarantypercent -- 担保比例
    ,effectivedate -- 法人身份证生效日期
    ,expiredate -- 法人身份证失效日期
    ,appointdate -- 预约放款日期
    ,transstatus -- 交易状态
    ,mybankaffiliateflag -- 是否我行关联人
    ,zhengxincheckresult -- 征信校验结果
    ,gongancheckresult -- 公安联网核查结果
    ,productid -- 产品编号
    ,manageuserid -- 客户经理编号
    ,manageorgid -- 客户经理机构编号
    ,applytime -- 申请时间
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,fkreleasetime -- 风控返回时间
    ,baseratetype -- 基准利率类型
    ,customerid -- 客户编号
    ,zzm -- 中征码
    ,entscale -- 企业规模（行内）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 信贷唯一主键约束
    ,brno -- 合作机构号
    ,seqno -- 流水号
    ,corpname -- 企业全称
    ,regarea -- 注册国家或地区
    ,regadmarea -- 注册地行政区划
    ,regaddress -- 注册地址
    ,province -- 省份
    ,orgcode -- 组织机构代码
    ,regtype -- 注册或登记证件类型
    ,regnumber -- 注册或登记证件号码
    ,taxnumber -- 税务登记证号码
    ,socialunifiedcreditcode -- 社会统一信用代码
    ,category -- 国标行业分类
    ,busscale -- 企业规模代码
    ,smallcorpiden -- 银监会小企业标识
    ,custname -- 法人名称
    ,idtype -- 证件类型代码
    ,idno -- 证件编号
    ,sex -- 性别代码
    ,nationality -- 国籍代码
    ,career -- 职业代码
    ,birth -- 出生日
    ,telno -- 联系电话号码
    ,phoneno -- 手机号码
    ,pactamt -- 贷款合同金额
    ,lnrate -- 利率（年）
    ,apparea -- 申请地点
    ,appuse -- 申请用途
    ,termmon -- 合同期限（月）
    ,voutype -- 担保方式代码
    ,enddate -- 到期日
    ,paytype -- 扣款日类型
    ,payday -- 扣款日期
    ,merchantno -- 商户号
    ,busilicenseid -- 营业执照号
    ,busilicenseexpiredate -- 营业执照有效截止日期
    ,registerdate -- 成立日期
    ,operatinglife -- 经营年限
    ,staffnumber -- 员工人数
    ,needrefuse -- 需要拒绝
    ,legalbankcard -- 银行卡号
    ,legalmobile -- 手机号码
    ,quotamod -- 模型核额额度
    ,custlevel -- 内部评级
    ,loannum -- 贷款笔数
    ,enterprisecerttype -- 企业证件类型
    ,enterprisecertendtime -- 企业证件到期日
    ,custid -- ECIF客户号
    ,signingenpauthtime -- 企业征信授权书签署时间
    ,signingpersonauthtime -- 个人征信授权书签署时间
    ,signingenpauthseq -- 企业征信授权书签署流水号
    ,signingpersonauthseq -- 个人征信授权书签署流水号
    ,loantype -- 贷款形式
    ,loanacctno -- 原借据号
    ,guarantytype -- 是否银担业务
    ,guarantyorgname -- 担保公司名称
    ,guarantycerttype -- 担保公司证件类型
    ,guarantycertno -- 担保公司证件号码
    ,guarantypercent -- 担保比例
    ,effectivedate -- 法人身份证生效日期
    ,expiredate -- 法人身份证失效日期
    ,appointdate -- 预约放款日期
    ,transstatus -- 交易状态
    ,mybankaffiliateflag -- 是否我行关联人
    ,zhengxincheckresult -- 征信校验结果
    ,gongancheckresult -- 公安联网核查结果
    ,productid -- 产品编号
    ,manageuserid -- 客户经理编号
    ,manageorgid -- 客户经理机构编号
    ,applytime -- 申请时间
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,fkreleasetime -- 风控返回时间
    ,baseratetype -- 基准利率类型
    ,customerid -- 客户编号
    ,zzm -- 中征码
    ,entscale -- 企业规模（行内）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_putout_apply
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_putout_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_putout_apply_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_putout_apply to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_putout_apply_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_putout_apply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);