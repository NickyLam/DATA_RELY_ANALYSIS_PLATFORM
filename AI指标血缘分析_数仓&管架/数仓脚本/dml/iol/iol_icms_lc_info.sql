/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lc_info
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
create table ${iol_schema}.icms_lc_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lc_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lc_info_op purge;
drop table ${iol_schema}.icms_lc_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lc_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lc_info where 0=1;

create table ${iol_schema}.icms_lc_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lc_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lc_info_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,issuebank -- 开卡行
            ,applicantaddress -- 申请人地址
            ,lctype -- 信用证类型
            ,lcsum -- 金额
            ,importcargo -- 进口货物
            ,pricearticle -- 价格条款
            ,beneficiaryaddress -- 受益人地址
            ,lccurrency -- 币种
            ,lcterm -- 远期信用证付款期限
            ,authcertno -- 进口许可证或批文
            ,informstate -- 通知行国家
            ,inputdate -- 登记日期
            ,purpose -- 用途
            ,flag1 -- 远期信用证是否已承兑
            ,remark -- 备注
            ,lcno -- 信用证编号
            ,informbank -- 通知行
            ,applicant -- 借款人
            ,tradesum -- 议付单据金额(元)
            ,freightbilltype -- 货运单据种类
            ,issuestate -- 开证国家
            ,updatedate -- 更新日期
            ,loadingdate -- 开证日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,issuedate -- 开卡日期
            ,beneficiary -- 受益人
            ,validdate -- 信用证效期
            ,importtype -- 进口方式
            ,contractno -- 汽车买卖合同编号
            ,exporter -- 出口国
            ,documentdate -- 信用证交单期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lc_info_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,issuebank -- 开卡行
            ,applicantaddress -- 申请人地址
            ,lctype -- 信用证类型
            ,lcsum -- 金额
            ,importcargo -- 进口货物
            ,pricearticle -- 价格条款
            ,beneficiaryaddress -- 受益人地址
            ,lccurrency -- 币种
            ,lcterm -- 远期信用证付款期限
            ,authcertno -- 进口许可证或批文
            ,informstate -- 通知行国家
            ,inputdate -- 登记日期
            ,purpose -- 用途
            ,flag1 -- 远期信用证是否已承兑
            ,remark -- 备注
            ,lcno -- 信用证编号
            ,informbank -- 通知行
            ,applicant -- 借款人
            ,tradesum -- 议付单据金额(元)
            ,freightbilltype -- 货运单据种类
            ,issuestate -- 开证国家
            ,updatedate -- 更新日期
            ,loadingdate -- 开证日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,issuedate -- 开卡日期
            ,beneficiary -- 受益人
            ,validdate -- 信用证效期
            ,importtype -- 进口方式
            ,contractno -- 汽车买卖合同编号
            ,exporter -- 出口国
            ,documentdate -- 信用证交单期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.issuebank, o.issuebank) as issuebank -- 开卡行
    ,nvl(n.applicantaddress, o.applicantaddress) as applicantaddress -- 申请人地址
    ,nvl(n.lctype, o.lctype) as lctype -- 信用证类型
    ,nvl(n.lcsum, o.lcsum) as lcsum -- 金额
    ,nvl(n.importcargo, o.importcargo) as importcargo -- 进口货物
    ,nvl(n.pricearticle, o.pricearticle) as pricearticle -- 价格条款
    ,nvl(n.beneficiaryaddress, o.beneficiaryaddress) as beneficiaryaddress -- 受益人地址
    ,nvl(n.lccurrency, o.lccurrency) as lccurrency -- 币种
    ,nvl(n.lcterm, o.lcterm) as lcterm -- 远期信用证付款期限
    ,nvl(n.authcertno, o.authcertno) as authcertno -- 进口许可证或批文
    ,nvl(n.informstate, o.informstate) as informstate -- 通知行国家
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.flag1, o.flag1) as flag1 -- 远期信用证是否已承兑
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.lcno, o.lcno) as lcno -- 信用证编号
    ,nvl(n.informbank, o.informbank) as informbank -- 通知行
    ,nvl(n.applicant, o.applicant) as applicant -- 借款人
    ,nvl(n.tradesum, o.tradesum) as tradesum -- 议付单据金额(元)
    ,nvl(n.freightbilltype, o.freightbilltype) as freightbilltype -- 货运单据种类
    ,nvl(n.issuestate, o.issuestate) as issuestate -- 开证国家
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.loadingdate, o.loadingdate) as loadingdate -- 开证日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.issuedate, o.issuedate) as issuedate -- 开卡日期
    ,nvl(n.beneficiary, o.beneficiary) as beneficiary -- 受益人
    ,nvl(n.validdate, o.validdate) as validdate -- 信用证效期
    ,nvl(n.importtype, o.importtype) as importtype -- 进口方式
    ,nvl(n.contractno, o.contractno) as contractno -- 汽车买卖合同编号
    ,nvl(n.exporter, o.exporter) as exporter -- 出口国
    ,nvl(n.documentdate, o.documentdate) as documentdate -- 信用证交单期
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lc_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lc_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
where (
        o.serialno is null
        and o.objecttype is null
        and o.objectno is null
    )
    or (
        n.serialno is null
        and n.objecttype is null
        and n.objectno is null
    )
    or (
        o.issuebank <> n.issuebank
        or o.applicantaddress <> n.applicantaddress
        or o.lctype <> n.lctype
        or o.lcsum <> n.lcsum
        or o.importcargo <> n.importcargo
        or o.pricearticle <> n.pricearticle
        or o.beneficiaryaddress <> n.beneficiaryaddress
        or o.lccurrency <> n.lccurrency
        or o.lcterm <> n.lcterm
        or o.authcertno <> n.authcertno
        or o.informstate <> n.informstate
        or o.inputdate <> n.inputdate
        or o.purpose <> n.purpose
        or o.flag1 <> n.flag1
        or o.remark <> n.remark
        or o.lcno <> n.lcno
        or o.informbank <> n.informbank
        or o.applicant <> n.applicant
        or o.tradesum <> n.tradesum
        or o.freightbilltype <> n.freightbilltype
        or o.issuestate <> n.issuestate
        or o.updatedate <> n.updatedate
        or o.loadingdate <> n.loadingdate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.issuedate <> n.issuedate
        or o.beneficiary <> n.beneficiary
        or o.validdate <> n.validdate
        or o.importtype <> n.importtype
        or o.contractno <> n.contractno
        or o.exporter <> n.exporter
        or o.documentdate <> n.documentdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lc_info_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,issuebank -- 开卡行
            ,applicantaddress -- 申请人地址
            ,lctype -- 信用证类型
            ,lcsum -- 金额
            ,importcargo -- 进口货物
            ,pricearticle -- 价格条款
            ,beneficiaryaddress -- 受益人地址
            ,lccurrency -- 币种
            ,lcterm -- 远期信用证付款期限
            ,authcertno -- 进口许可证或批文
            ,informstate -- 通知行国家
            ,inputdate -- 登记日期
            ,purpose -- 用途
            ,flag1 -- 远期信用证是否已承兑
            ,remark -- 备注
            ,lcno -- 信用证编号
            ,informbank -- 通知行
            ,applicant -- 借款人
            ,tradesum -- 议付单据金额(元)
            ,freightbilltype -- 货运单据种类
            ,issuestate -- 开证国家
            ,updatedate -- 更新日期
            ,loadingdate -- 开证日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,issuedate -- 开卡日期
            ,beneficiary -- 受益人
            ,validdate -- 信用证效期
            ,importtype -- 进口方式
            ,contractno -- 汽车买卖合同编号
            ,exporter -- 出口国
            ,documentdate -- 信用证交单期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lc_info_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,issuebank -- 开卡行
            ,applicantaddress -- 申请人地址
            ,lctype -- 信用证类型
            ,lcsum -- 金额
            ,importcargo -- 进口货物
            ,pricearticle -- 价格条款
            ,beneficiaryaddress -- 受益人地址
            ,lccurrency -- 币种
            ,lcterm -- 远期信用证付款期限
            ,authcertno -- 进口许可证或批文
            ,informstate -- 通知行国家
            ,inputdate -- 登记日期
            ,purpose -- 用途
            ,flag1 -- 远期信用证是否已承兑
            ,remark -- 备注
            ,lcno -- 信用证编号
            ,informbank -- 通知行
            ,applicant -- 借款人
            ,tradesum -- 议付单据金额(元)
            ,freightbilltype -- 货运单据种类
            ,issuestate -- 开证国家
            ,updatedate -- 更新日期
            ,loadingdate -- 开证日期
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,issuedate -- 开卡日期
            ,beneficiary -- 受益人
            ,validdate -- 信用证效期
            ,importtype -- 进口方式
            ,contractno -- 汽车买卖合同编号
            ,exporter -- 出口国
            ,documentdate -- 信用证交单期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.issuebank -- 开卡行
    ,o.applicantaddress -- 申请人地址
    ,o.lctype -- 信用证类型
    ,o.lcsum -- 金额
    ,o.importcargo -- 进口货物
    ,o.pricearticle -- 价格条款
    ,o.beneficiaryaddress -- 受益人地址
    ,o.lccurrency -- 币种
    ,o.lcterm -- 远期信用证付款期限
    ,o.authcertno -- 进口许可证或批文
    ,o.informstate -- 通知行国家
    ,o.inputdate -- 登记日期
    ,o.purpose -- 用途
    ,o.flag1 -- 远期信用证是否已承兑
    ,o.remark -- 备注
    ,o.lcno -- 信用证编号
    ,o.informbank -- 通知行
    ,o.applicant -- 借款人
    ,o.tradesum -- 议付单据金额(元)
    ,o.freightbilltype -- 货运单据种类
    ,o.issuestate -- 开证国家
    ,o.updatedate -- 更新日期
    ,o.loadingdate -- 开证日期
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.issuedate -- 开卡日期
    ,o.beneficiary -- 受益人
    ,o.validdate -- 信用证效期
    ,o.importtype -- 进口方式
    ,o.contractno -- 汽车买卖合同编号
    ,o.exporter -- 出口国
    ,o.documentdate -- 信用证交单期
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
from ${iol_schema}.icms_lc_info_bk o
    left join ${iol_schema}.icms_lc_info_op n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lc_info_cl d
        on
            o.serialno = d.serialno
            and o.objecttype = d.objecttype
            and o.objectno = d.objectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lc_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lc_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lc_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lc_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lc_info exchange partition p_${batch_date} with table ${iol_schema}.icms_lc_info_cl;
alter table ${iol_schema}.icms_lc_info exchange partition p_20991231 with table ${iol_schema}.icms_lc_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lc_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lc_info_op purge;
drop table ${iol_schema}.icms_lc_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lc_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lc_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
