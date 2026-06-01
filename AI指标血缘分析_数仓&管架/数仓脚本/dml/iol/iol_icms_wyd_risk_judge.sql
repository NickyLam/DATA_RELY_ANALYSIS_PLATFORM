/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_risk_judge
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_wyd_risk_judge_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wyd_risk_judge
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_risk_judge_op purge;
drop table ${iol_schema}.icms_wyd_risk_judge_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_risk_judge_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_risk_judge where 0=1;

create table ${iol_schema}.icms_wyd_risk_judge_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_risk_judge where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_risk_judge_cl(
            serialno -- 流水号
            ,riskjudgeseq -- 风险判别流水号
            ,applytime -- 申请时间
            ,intfccalltime -- 接口调用时间
            ,scenetype -- 场景类型
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,regarea -- 注册国家或地区
            ,regadmarea -- 注册地行政区划
            ,regaddress -- 注册地址
            ,province -- 省份
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,wzccif -- 微众客户ID
            ,category -- 国标行业分类
            ,smallcorpiden -- 银监会小企业标识
            ,registerdate -- 成立日期
            ,operyears -- 经营年限
            ,staffnumber -- 员工人数
            ,legalname -- 法人名称
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,legalcertexpiredate -- 法人证件失效日期
            ,legalsex -- 法人性别
            ,legalethnicity -- 法人民族
            ,legaladdress -- 法人证件地址
            ,legalnationality -- 法人国籍
            ,legalcareer -- 法人职业
            ,legalbirth -- 法人出生日期
            ,legalphoneno -- 法人手机号码
            ,legalbankcard -- 法人认证银行卡号
            ,legalmobile -- 法人认证手机号码
            ,legalecif -- 法人ECIF
            ,signingenpauthtime -- 企业征信授权书签署时间
            ,signingpersonauthtime -- 个人征信授权书签署时间
            ,signingenpauthseq -- 企业征信授权书签署流水号
            ,signingpersonauthseq -- 个人征信授权书签署流水号
            ,customerid -- 客户编号（ECIF）
            ,intfccallresptime -- 接口调用返回时间
            ,riskresult -- 风控结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_risk_judge_op(
            serialno -- 流水号
            ,riskjudgeseq -- 风险判别流水号
            ,applytime -- 申请时间
            ,intfccalltime -- 接口调用时间
            ,scenetype -- 场景类型
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,regarea -- 注册国家或地区
            ,regadmarea -- 注册地行政区划
            ,regaddress -- 注册地址
            ,province -- 省份
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,wzccif -- 微众客户ID
            ,category -- 国标行业分类
            ,smallcorpiden -- 银监会小企业标识
            ,registerdate -- 成立日期
            ,operyears -- 经营年限
            ,staffnumber -- 员工人数
            ,legalname -- 法人名称
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,legalcertexpiredate -- 法人证件失效日期
            ,legalsex -- 法人性别
            ,legalethnicity -- 法人民族
            ,legaladdress -- 法人证件地址
            ,legalnationality -- 法人国籍
            ,legalcareer -- 法人职业
            ,legalbirth -- 法人出生日期
            ,legalphoneno -- 法人手机号码
            ,legalbankcard -- 法人认证银行卡号
            ,legalmobile -- 法人认证手机号码
            ,legalecif -- 法人ECIF
            ,signingenpauthtime -- 企业征信授权书签署时间
            ,signingpersonauthtime -- 个人征信授权书签署时间
            ,signingenpauthseq -- 企业征信授权书签署流水号
            ,signingpersonauthseq -- 个人征信授权书签署流水号
            ,customerid -- 客户编号（ECIF）
            ,intfccallresptime -- 接口调用返回时间
            ,riskresult -- 风控结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.riskjudgeseq, o.riskjudgeseq) as riskjudgeseq -- 风险判别流水号
    ,nvl(n.applytime, o.applytime) as applytime -- 申请时间
    ,nvl(n.intfccalltime, o.intfccalltime) as intfccalltime -- 接口调用时间
    ,nvl(n.scenetype, o.scenetype) as scenetype -- 场景类型
    ,nvl(n.stlprdid, o.stlprdid) as stlprdid -- 核算产品编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.recommender, o.recommender) as recommender -- 推荐人
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.taxpayerid, o.taxpayerid) as taxpayerid -- 纳税人识别号
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称
    ,nvl(n.regarea, o.regarea) as regarea -- 注册国家或地区
    ,nvl(n.regadmarea, o.regadmarea) as regadmarea -- 注册地行政区划
    ,nvl(n.regaddress, o.regaddress) as regaddress -- 注册地址
    ,nvl(n.province, o.province) as province -- 省份
    ,nvl(n.orgbranchcode, o.orgbranchcode) as orgbranchcode -- 组织机构代码
    ,nvl(n.socialunitycreditcode, o.socialunitycreditcode) as socialunitycreditcode -- 社会统一信用代码
    ,nvl(n.busiregisterno, o.busiregisterno) as busiregisterno -- 工商注册号
    ,nvl(n.wzccif, o.wzccif) as wzccif -- 微众客户ID
    ,nvl(n.category, o.category) as category -- 国标行业分类
    ,nvl(n.smallcorpiden, o.smallcorpiden) as smallcorpiden -- 银监会小企业标识
    ,nvl(n.registerdate, o.registerdate) as registerdate -- 成立日期
    ,nvl(n.operyears, o.operyears) as operyears -- 经营年限
    ,nvl(n.staffnumber, o.staffnumber) as staffnumber -- 员工人数
    ,nvl(n.legalname, o.legalname) as legalname -- 法人名称
    ,nvl(n.legalcertid, o.legalcertid) as legalcertid -- 法人证件号
    ,nvl(n.legalcerttype, o.legalcerttype) as legalcerttype -- 法人证件类型
    ,nvl(n.legalcertexpiredate, o.legalcertexpiredate) as legalcertexpiredate -- 法人证件失效日期
    ,nvl(n.legalsex, o.legalsex) as legalsex -- 法人性别
    ,nvl(n.legalethnicity, o.legalethnicity) as legalethnicity -- 法人民族
    ,nvl(n.legaladdress, o.legaladdress) as legaladdress -- 法人证件地址
    ,nvl(n.legalnationality, o.legalnationality) as legalnationality -- 法人国籍
    ,nvl(n.legalcareer, o.legalcareer) as legalcareer -- 法人职业
    ,nvl(n.legalbirth, o.legalbirth) as legalbirth -- 法人出生日期
    ,nvl(n.legalphoneno, o.legalphoneno) as legalphoneno -- 法人手机号码
    ,nvl(n.legalbankcard, o.legalbankcard) as legalbankcard -- 法人认证银行卡号
    ,nvl(n.legalmobile, o.legalmobile) as legalmobile -- 法人认证手机号码
    ,nvl(n.legalecif, o.legalecif) as legalecif -- 法人ECIF
    ,nvl(n.signingenpauthtime, o.signingenpauthtime) as signingenpauthtime -- 企业征信授权书签署时间
    ,nvl(n.signingpersonauthtime, o.signingpersonauthtime) as signingpersonauthtime -- 个人征信授权书签署时间
    ,nvl(n.signingenpauthseq, o.signingenpauthseq) as signingenpauthseq -- 企业征信授权书签署流水号
    ,nvl(n.signingpersonauthseq, o.signingpersonauthseq) as signingpersonauthseq -- 个人征信授权书签署流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号（ECIF）
    ,nvl(n.intfccallresptime, o.intfccallresptime) as intfccallresptime -- 接口调用返回时间
    ,nvl(n.riskresult, o.riskresult) as riskresult -- 风控结果
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wyd_risk_judge_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wyd_risk_judge where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.riskjudgeseq <> n.riskjudgeseq
        or o.applytime <> n.applytime
        or o.intfccalltime <> n.intfccalltime
        or o.scenetype <> n.scenetype
        or o.stlprdid <> n.stlprdid
        or o.productid <> n.productid
        or o.recommender <> n.recommender
        or o.ccy <> n.ccy
        or o.taxpayerid <> n.taxpayerid
        or o.enterprisename <> n.enterprisename
        or o.regarea <> n.regarea
        or o.regadmarea <> n.regadmarea
        or o.regaddress <> n.regaddress
        or o.province <> n.province
        or o.orgbranchcode <> n.orgbranchcode
        or o.socialunitycreditcode <> n.socialunitycreditcode
        or o.busiregisterno <> n.busiregisterno
        or o.wzccif <> n.wzccif
        or o.category <> n.category
        or o.smallcorpiden <> n.smallcorpiden
        or o.registerdate <> n.registerdate
        or o.operyears <> n.operyears
        or o.staffnumber <> n.staffnumber
        or o.legalname <> n.legalname
        or o.legalcertid <> n.legalcertid
        or o.legalcerttype <> n.legalcerttype
        or o.legalcertexpiredate <> n.legalcertexpiredate
        or o.legalsex <> n.legalsex
        or o.legalethnicity <> n.legalethnicity
        or o.legaladdress <> n.legaladdress
        or o.legalnationality <> n.legalnationality
        or o.legalcareer <> n.legalcareer
        or o.legalbirth <> n.legalbirth
        or o.legalphoneno <> n.legalphoneno
        or o.legalbankcard <> n.legalbankcard
        or o.legalmobile <> n.legalmobile
        or o.legalecif <> n.legalecif
        or o.signingenpauthtime <> n.signingenpauthtime
        or o.signingpersonauthtime <> n.signingpersonauthtime
        or o.signingenpauthseq <> n.signingenpauthseq
        or o.signingpersonauthseq <> n.signingpersonauthseq
        or o.customerid <> n.customerid
        or o.intfccallresptime <> n.intfccallresptime
        or o.riskresult <> n.riskresult
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_risk_judge_cl(
            serialno -- 流水号
            ,riskjudgeseq -- 风险判别流水号
            ,applytime -- 申请时间
            ,intfccalltime -- 接口调用时间
            ,scenetype -- 场景类型
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,regarea -- 注册国家或地区
            ,regadmarea -- 注册地行政区划
            ,regaddress -- 注册地址
            ,province -- 省份
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,wzccif -- 微众客户ID
            ,category -- 国标行业分类
            ,smallcorpiden -- 银监会小企业标识
            ,registerdate -- 成立日期
            ,operyears -- 经营年限
            ,staffnumber -- 员工人数
            ,legalname -- 法人名称
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,legalcertexpiredate -- 法人证件失效日期
            ,legalsex -- 法人性别
            ,legalethnicity -- 法人民族
            ,legaladdress -- 法人证件地址
            ,legalnationality -- 法人国籍
            ,legalcareer -- 法人职业
            ,legalbirth -- 法人出生日期
            ,legalphoneno -- 法人手机号码
            ,legalbankcard -- 法人认证银行卡号
            ,legalmobile -- 法人认证手机号码
            ,legalecif -- 法人ECIF
            ,signingenpauthtime -- 企业征信授权书签署时间
            ,signingpersonauthtime -- 个人征信授权书签署时间
            ,signingenpauthseq -- 企业征信授权书签署流水号
            ,signingpersonauthseq -- 个人征信授权书签署流水号
            ,customerid -- 客户编号（ECIF）
            ,intfccallresptime -- 接口调用返回时间
            ,riskresult -- 风控结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_risk_judge_op(
            serialno -- 流水号
            ,riskjudgeseq -- 风险判别流水号
            ,applytime -- 申请时间
            ,intfccalltime -- 接口调用时间
            ,scenetype -- 场景类型
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,regarea -- 注册国家或地区
            ,regadmarea -- 注册地行政区划
            ,regaddress -- 注册地址
            ,province -- 省份
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,wzccif -- 微众客户ID
            ,category -- 国标行业分类
            ,smallcorpiden -- 银监会小企业标识
            ,registerdate -- 成立日期
            ,operyears -- 经营年限
            ,staffnumber -- 员工人数
            ,legalname -- 法人名称
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,legalcertexpiredate -- 法人证件失效日期
            ,legalsex -- 法人性别
            ,legalethnicity -- 法人民族
            ,legaladdress -- 法人证件地址
            ,legalnationality -- 法人国籍
            ,legalcareer -- 法人职业
            ,legalbirth -- 法人出生日期
            ,legalphoneno -- 法人手机号码
            ,legalbankcard -- 法人认证银行卡号
            ,legalmobile -- 法人认证手机号码
            ,legalecif -- 法人ECIF
            ,signingenpauthtime -- 企业征信授权书签署时间
            ,signingpersonauthtime -- 个人征信授权书签署时间
            ,signingenpauthseq -- 企业征信授权书签署流水号
            ,signingpersonauthseq -- 个人征信授权书签署流水号
            ,customerid -- 客户编号（ECIF）
            ,intfccallresptime -- 接口调用返回时间
            ,riskresult -- 风控结果
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.riskjudgeseq -- 风险判别流水号
    ,o.applytime -- 申请时间
    ,o.intfccalltime -- 接口调用时间
    ,o.scenetype -- 场景类型
    ,o.stlprdid -- 核算产品编号
    ,o.productid -- 产品编号
    ,o.recommender -- 推荐人
    ,o.ccy -- 币种
    ,o.taxpayerid -- 纳税人识别号
    ,o.enterprisename -- 企业名称
    ,o.regarea -- 注册国家或地区
    ,o.regadmarea -- 注册地行政区划
    ,o.regaddress -- 注册地址
    ,o.province -- 省份
    ,o.orgbranchcode -- 组织机构代码
    ,o.socialunitycreditcode -- 社会统一信用代码
    ,o.busiregisterno -- 工商注册号
    ,o.wzccif -- 微众客户ID
    ,o.category -- 国标行业分类
    ,o.smallcorpiden -- 银监会小企业标识
    ,o.registerdate -- 成立日期
    ,o.operyears -- 经营年限
    ,o.staffnumber -- 员工人数
    ,o.legalname -- 法人名称
    ,o.legalcertid -- 法人证件号
    ,o.legalcerttype -- 法人证件类型
    ,o.legalcertexpiredate -- 法人证件失效日期
    ,o.legalsex -- 法人性别
    ,o.legalethnicity -- 法人民族
    ,o.legaladdress -- 法人证件地址
    ,o.legalnationality -- 法人国籍
    ,o.legalcareer -- 法人职业
    ,o.legalbirth -- 法人出生日期
    ,o.legalphoneno -- 法人手机号码
    ,o.legalbankcard -- 法人认证银行卡号
    ,o.legalmobile -- 法人认证手机号码
    ,o.legalecif -- 法人ECIF
    ,o.signingenpauthtime -- 企业征信授权书签署时间
    ,o.signingpersonauthtime -- 个人征信授权书签署时间
    ,o.signingenpauthseq -- 企业征信授权书签署流水号
    ,o.signingpersonauthseq -- 个人征信授权书签署流水号
    ,o.customerid -- 客户编号（ECIF）
    ,o.intfccallresptime -- 接口调用返回时间
    ,o.riskresult -- 风控结果
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_wyd_risk_judge_bk o
    left join ${iol_schema}.icms_wyd_risk_judge_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wyd_risk_judge_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wyd_risk_judge;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wyd_risk_judge') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wyd_risk_judge drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wyd_risk_judge add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wyd_risk_judge exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_risk_judge_cl;
alter table ${iol_schema}.icms_wyd_risk_judge exchange partition p_20991231 with table ${iol_schema}.icms_wyd_risk_judge_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_risk_judge to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_risk_judge_op purge;
drop table ${iol_schema}.icms_wyd_risk_judge_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wyd_risk_judge_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_risk_judge',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
