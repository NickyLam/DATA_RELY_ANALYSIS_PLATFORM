/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_lmt_resu_receive
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
create table ${iol_schema}.icms_wyd_lmt_resu_receive_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wyd_lmt_resu_receive
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_lmt_resu_receive_op purge;
drop table ${iol_schema}.icms_wyd_lmt_resu_receive_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_lmt_resu_receive_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_lmt_resu_receive where 0=1;

create table ${iol_schema}.icms_wyd_lmt_resu_receive_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_lmt_resu_receive where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_lmt_resu_receive_cl(
            serialno -- 流水号
            ,lmtresuseq -- 额度结果流水号
            ,riskjudgeseq -- 风险判别流水号
            ,intfccalltime -- 接口调用时间
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,wzccif -- 微众客户ID
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,legalname -- 法人名称
            ,legalmobile -- 法人手机号码
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,customerid -- 客户编号（ECIF）
            ,modelquotalmt -- 模型核额额度
            ,dayrate -- 日利率
            ,prdterm -- 产品期限
            ,custlevel -- 内部评级
            ,quotafailrsns -- 核额失败原因
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,riskresult -- 风控结果
            ,finalloanrate -- 最终审批利率
            ,finalapplyamount -- 最终审批额度
            ,finalapplyterm -- 最终审批期限
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,ismoneylaunderlz -- 是否命中反洗钱汇总
            ,refunum -- 拒绝码
            ,updateamount -- 我行修改额度
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,dealstatus -- 额度确认处理状态
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_lmt_resu_receive_op(
            serialno -- 流水号
            ,lmtresuseq -- 额度结果流水号
            ,riskjudgeseq -- 风险判别流水号
            ,intfccalltime -- 接口调用时间
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,wzccif -- 微众客户ID
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,legalname -- 法人名称
            ,legalmobile -- 法人手机号码
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,customerid -- 客户编号（ECIF）
            ,modelquotalmt -- 模型核额额度
            ,dayrate -- 日利率
            ,prdterm -- 产品期限
            ,custlevel -- 内部评级
            ,quotafailrsns -- 核额失败原因
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,riskresult -- 风控结果
            ,finalloanrate -- 最终审批利率
            ,finalapplyamount -- 最终审批额度
            ,finalapplyterm -- 最终审批期限
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,ismoneylaunderlz -- 是否命中反洗钱汇总
            ,refunum -- 拒绝码
            ,updateamount -- 我行修改额度
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,dealstatus -- 额度确认处理状态
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.lmtresuseq, o.lmtresuseq) as lmtresuseq -- 额度结果流水号
    ,nvl(n.riskjudgeseq, o.riskjudgeseq) as riskjudgeseq -- 风险判别流水号
    ,nvl(n.intfccalltime, o.intfccalltime) as intfccalltime -- 接口调用时间
    ,nvl(n.recommender, o.recommender) as recommender -- 推荐人
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.taxpayerid, o.taxpayerid) as taxpayerid -- 纳税人识别号
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称
    ,nvl(n.wzccif, o.wzccif) as wzccif -- 微众客户ID
    ,nvl(n.orgbranchcode, o.orgbranchcode) as orgbranchcode -- 组织机构代码
    ,nvl(n.socialunitycreditcode, o.socialunitycreditcode) as socialunitycreditcode -- 社会统一信用代码
    ,nvl(n.busiregisterno, o.busiregisterno) as busiregisterno -- 工商注册号
    ,nvl(n.legalname, o.legalname) as legalname -- 法人名称
    ,nvl(n.legalmobile, o.legalmobile) as legalmobile -- 法人手机号码
    ,nvl(n.legalcertid, o.legalcertid) as legalcertid -- 法人证件号
    ,nvl(n.legalcerttype, o.legalcerttype) as legalcerttype -- 法人证件类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号（ECIF）
    ,nvl(n.modelquotalmt, o.modelquotalmt) as modelquotalmt -- 模型核额额度
    ,nvl(n.dayrate, o.dayrate) as dayrate -- 日利率
    ,nvl(n.prdterm, o.prdterm) as prdterm -- 产品期限
    ,nvl(n.custlevel, o.custlevel) as custlevel -- 内部评级
    ,nvl(n.quotafailrsns, o.quotafailrsns) as quotafailrsns -- 核额失败原因
    ,nvl(n.stlprdid, o.stlprdid) as stlprdid -- 核算产品编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.riskresult, o.riskresult) as riskresult -- 风控结果
    ,nvl(n.finalloanrate, o.finalloanrate) as finalloanrate -- 最终审批利率
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 最终审批额度
    ,nvl(n.finalapplyterm, o.finalapplyterm) as finalapplyterm -- 最终审批期限
    ,nvl(n.risknote, o.risknote) as risknote -- 备注
    ,nvl(n.riskwarm, o.riskwarm) as riskwarm -- 预警
    ,nvl(n.ismoneylaunderlz, o.ismoneylaunderlz) as ismoneylaunderlz -- 是否命中反洗钱汇总
    ,nvl(n.refunum, o.refunum) as refunum -- 拒绝码
    ,nvl(n.updateamount, o.updateamount) as updateamount -- 我行修改额度
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.dealstatus, o.dealstatus) as dealstatus -- 额度确认处理状态
    ,nvl(n.noncestr, o.noncestr) as noncestr -- 请求微众流水
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
from (select * from ${iol_schema}.icms_wyd_lmt_resu_receive_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wyd_lmt_resu_receive where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.lmtresuseq <> n.lmtresuseq
        or o.riskjudgeseq <> n.riskjudgeseq
        or o.intfccalltime <> n.intfccalltime
        or o.recommender <> n.recommender
        or o.ccy <> n.ccy
        or o.taxpayerid <> n.taxpayerid
        or o.enterprisename <> n.enterprisename
        or o.wzccif <> n.wzccif
        or o.orgbranchcode <> n.orgbranchcode
        or o.socialunitycreditcode <> n.socialunitycreditcode
        or o.busiregisterno <> n.busiregisterno
        or o.legalname <> n.legalname
        or o.legalmobile <> n.legalmobile
        or o.legalcertid <> n.legalcertid
        or o.legalcerttype <> n.legalcerttype
        or o.customerid <> n.customerid
        or o.modelquotalmt <> n.modelquotalmt
        or o.dayrate <> n.dayrate
        or o.prdterm <> n.prdterm
        or o.custlevel <> n.custlevel
        or o.quotafailrsns <> n.quotafailrsns
        or o.stlprdid <> n.stlprdid
        or o.productid <> n.productid
        or o.riskresult <> n.riskresult
        or o.finalloanrate <> n.finalloanrate
        or o.finalapplyamount <> n.finalapplyamount
        or o.finalapplyterm <> n.finalapplyterm
        or o.risknote <> n.risknote
        or o.riskwarm <> n.riskwarm
        or o.ismoneylaunderlz <> n.ismoneylaunderlz
        or o.refunum <> n.refunum
        or o.updateamount <> n.updateamount
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.dealstatus <> n.dealstatus
        or o.noncestr <> n.noncestr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_lmt_resu_receive_cl(
            serialno -- 流水号
            ,lmtresuseq -- 额度结果流水号
            ,riskjudgeseq -- 风险判别流水号
            ,intfccalltime -- 接口调用时间
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,wzccif -- 微众客户ID
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,legalname -- 法人名称
            ,legalmobile -- 法人手机号码
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,customerid -- 客户编号（ECIF）
            ,modelquotalmt -- 模型核额额度
            ,dayrate -- 日利率
            ,prdterm -- 产品期限
            ,custlevel -- 内部评级
            ,quotafailrsns -- 核额失败原因
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,riskresult -- 风控结果
            ,finalloanrate -- 最终审批利率
            ,finalapplyamount -- 最终审批额度
            ,finalapplyterm -- 最终审批期限
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,ismoneylaunderlz -- 是否命中反洗钱汇总
            ,refunum -- 拒绝码
            ,updateamount -- 我行修改额度
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,dealstatus -- 额度确认处理状态
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_lmt_resu_receive_op(
            serialno -- 流水号
            ,lmtresuseq -- 额度结果流水号
            ,riskjudgeseq -- 风险判别流水号
            ,intfccalltime -- 接口调用时间
            ,recommender -- 推荐人
            ,ccy -- 币种
            ,taxpayerid -- 纳税人识别号
            ,enterprisename -- 企业名称
            ,wzccif -- 微众客户ID
            ,orgbranchcode -- 组织机构代码
            ,socialunitycreditcode -- 社会统一信用代码
            ,busiregisterno -- 工商注册号
            ,legalname -- 法人名称
            ,legalmobile -- 法人手机号码
            ,legalcertid -- 法人证件号
            ,legalcerttype -- 法人证件类型
            ,customerid -- 客户编号（ECIF）
            ,modelquotalmt -- 模型核额额度
            ,dayrate -- 日利率
            ,prdterm -- 产品期限
            ,custlevel -- 内部评级
            ,quotafailrsns -- 核额失败原因
            ,stlprdid -- 核算产品编号
            ,productid -- 产品编号
            ,riskresult -- 风控结果
            ,finalloanrate -- 最终审批利率
            ,finalapplyamount -- 最终审批额度
            ,finalapplyterm -- 最终审批期限
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,ismoneylaunderlz -- 是否命中反洗钱汇总
            ,refunum -- 拒绝码
            ,updateamount -- 我行修改额度
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,dealstatus -- 额度确认处理状态
            ,noncestr -- 请求微众流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.lmtresuseq -- 额度结果流水号
    ,o.riskjudgeseq -- 风险判别流水号
    ,o.intfccalltime -- 接口调用时间
    ,o.recommender -- 推荐人
    ,o.ccy -- 币种
    ,o.taxpayerid -- 纳税人识别号
    ,o.enterprisename -- 企业名称
    ,o.wzccif -- 微众客户ID
    ,o.orgbranchcode -- 组织机构代码
    ,o.socialunitycreditcode -- 社会统一信用代码
    ,o.busiregisterno -- 工商注册号
    ,o.legalname -- 法人名称
    ,o.legalmobile -- 法人手机号码
    ,o.legalcertid -- 法人证件号
    ,o.legalcerttype -- 法人证件类型
    ,o.customerid -- 客户编号（ECIF）
    ,o.modelquotalmt -- 模型核额额度
    ,o.dayrate -- 日利率
    ,o.prdterm -- 产品期限
    ,o.custlevel -- 内部评级
    ,o.quotafailrsns -- 核额失败原因
    ,o.stlprdid -- 核算产品编号
    ,o.productid -- 产品编号
    ,o.riskresult -- 风控结果
    ,o.finalloanrate -- 最终审批利率
    ,o.finalapplyamount -- 最终审批额度
    ,o.finalapplyterm -- 最终审批期限
    ,o.risknote -- 备注
    ,o.riskwarm -- 预警
    ,o.ismoneylaunderlz -- 是否命中反洗钱汇总
    ,o.refunum -- 拒绝码
    ,o.updateamount -- 我行修改额度
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.dealstatus -- 额度确认处理状态
    ,o.noncestr -- 请求微众流水
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
from ${iol_schema}.icms_wyd_lmt_resu_receive_bk o
    left join ${iol_schema}.icms_wyd_lmt_resu_receive_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wyd_lmt_resu_receive_cl d
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
--truncate table ${iol_schema}.icms_wyd_lmt_resu_receive;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wyd_lmt_resu_receive') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wyd_lmt_resu_receive drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wyd_lmt_resu_receive add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wyd_lmt_resu_receive exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_lmt_resu_receive_cl;
alter table ${iol_schema}.icms_wyd_lmt_resu_receive exchange partition p_20991231 with table ${iol_schema}.icms_wyd_lmt_resu_receive_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_lmt_resu_receive to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_lmt_resu_receive_op purge;
drop table ${iol_schema}.icms_wyd_lmt_resu_receive_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wyd_lmt_resu_receive_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_lmt_resu_receive',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
