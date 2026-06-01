/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_write_off_duebill
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
create table ${iol_schema}.icms_afterloan_write_off_duebill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_afterloan_write_off_duebill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_write_off_duebill_op purge;
drop table ${iol_schema}.icms_afterloan_write_off_duebill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_write_off_duebill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_write_off_duebill where 0=1;

create table ${iol_schema}.icms_afterloan_write_off_duebill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_afterloan_write_off_duebill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_write_off_duebill_cl(
            bdserialno -- 借据编号
            ,overduedays -- 逾期天数
            ,certtype -- 证件类型
            ,actlwriteoffinint -- 核销表内利息
            ,collectionnum -- 催收次数
            ,writeoffdate -- 指该贷款首次的核销日期。
            ,capitalpenaltybalance -- 罚息
            ,filepath -- 文件路径
            ,inboundbatno -- 入库批次号
            ,enddate -- 贷款逾期日
            ,actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
            ,advancepayment -- 核销垫付费用
            ,certid -- 证件号码
            ,executerate -- 执行年利率
            ,termmonth -- 期限
            ,startdate -- 贷款发放日
            ,loanbalance -- 存款余额
            ,inbounddate -- 入库日期
            ,customerid -- 客户编号
            ,finabrid -- 账务机构
            ,customername -- 客户名称
            ,maturity -- 借据到期日
            ,overdueinterest -- 利息
            ,writeoffstatus -- 核销状态
            ,remark -- 备注
            ,sex -- 性别
            ,balance -- 借据余额
            ,billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businesssum -- 借据金额
            ,repaytype -- 还款方式
            ,loansum -- 贷款余额
            ,businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
            ,actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
            ,fiveriskcla -- 五级风险分类
            ,updatedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_write_off_duebill_op(
            bdserialno -- 借据编号
            ,overduedays -- 逾期天数
            ,certtype -- 证件类型
            ,actlwriteoffinint -- 核销表内利息
            ,collectionnum -- 催收次数
            ,writeoffdate -- 指该贷款首次的核销日期。
            ,capitalpenaltybalance -- 罚息
            ,filepath -- 文件路径
            ,inboundbatno -- 入库批次号
            ,enddate -- 贷款逾期日
            ,actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
            ,advancepayment -- 核销垫付费用
            ,certid -- 证件号码
            ,executerate -- 执行年利率
            ,termmonth -- 期限
            ,startdate -- 贷款发放日
            ,loanbalance -- 存款余额
            ,inbounddate -- 入库日期
            ,customerid -- 客户编号
            ,finabrid -- 账务机构
            ,customername -- 客户名称
            ,maturity -- 借据到期日
            ,overdueinterest -- 利息
            ,writeoffstatus -- 核销状态
            ,remark -- 备注
            ,sex -- 性别
            ,balance -- 借据余额
            ,billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businesssum -- 借据金额
            ,repaytype -- 还款方式
            ,loansum -- 贷款余额
            ,businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
            ,actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
            ,fiveriskcla -- 五级风险分类
            ,updatedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bdserialno, o.bdserialno) as bdserialno -- 借据编号
    ,nvl(n.overduedays, o.overduedays) as overduedays -- 逾期天数
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.actlwriteoffinint, o.actlwriteoffinint) as actlwriteoffinint -- 核销表内利息
    ,nvl(n.collectionnum, o.collectionnum) as collectionnum -- 催收次数
    ,nvl(n.writeoffdate, o.writeoffdate) as writeoffdate -- 指该贷款首次的核销日期。
    ,nvl(n.capitalpenaltybalance, o.capitalpenaltybalance) as capitalpenaltybalance -- 罚息
    ,nvl(n.filepath, o.filepath) as filepath -- 文件路径
    ,nvl(n.inboundbatno, o.inboundbatno) as inboundbatno -- 入库批次号
    ,nvl(n.enddate, o.enddate) as enddate -- 贷款逾期日
    ,nvl(n.actlwriteoffoffint, o.actlwriteoffoffint) as actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
    ,nvl(n.advancepayment, o.advancepayment) as advancepayment -- 核销垫付费用
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.executerate, o.executerate) as executerate -- 执行年利率
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限
    ,nvl(n.startdate, o.startdate) as startdate -- 贷款发放日
    ,nvl(n.loanbalance, o.loanbalance) as loanbalance -- 存款余额
    ,nvl(n.inbounddate, o.inbounddate) as inbounddate -- 入库日期
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.finabrid, o.finabrid) as finabrid -- 账务机构
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.maturity, o.maturity) as maturity -- 借据到期日
    ,nvl(n.overdueinterest, o.overdueinterest) as overdueinterest -- 利息
    ,nvl(n.writeoffstatus, o.writeoffstatus) as writeoffstatus -- 核销状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.balance, o.balance) as balance -- 借据余额
    ,nvl(n.billtype, o.billtype) as billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 借据金额
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.loansum, o.loansum) as loansum -- 贷款余额
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
    ,nvl(n.actlwriteoffloanprcp, o.actlwriteoffloanprcp) as actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
    ,nvl(n.fiveriskcla, o.fiveriskcla) as fiveriskcla -- 五级风险分类
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 
    ,case when
            n.bdserialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bdserialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bdserialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_afterloan_write_off_duebill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_afterloan_write_off_duebill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bdserialno = n.bdserialno
where (
        o.bdserialno is null
    )
    or (
        n.bdserialno is null
    )
    or (
        o.overduedays <> n.overduedays
        or o.certtype <> n.certtype
        or o.actlwriteoffinint <> n.actlwriteoffinint
        or o.collectionnum <> n.collectionnum
        or o.writeoffdate <> n.writeoffdate
        or o.capitalpenaltybalance <> n.capitalpenaltybalance
        or o.filepath <> n.filepath
        or o.inboundbatno <> n.inboundbatno
        or o.enddate <> n.enddate
        or o.actlwriteoffoffint <> n.actlwriteoffoffint
        or o.advancepayment <> n.advancepayment
        or o.certid <> n.certid
        or o.executerate <> n.executerate
        or o.termmonth <> n.termmonth
        or o.startdate <> n.startdate
        or o.loanbalance <> n.loanbalance
        or o.inbounddate <> n.inbounddate
        or o.customerid <> n.customerid
        or o.finabrid <> n.finabrid
        or o.customername <> n.customername
        or o.maturity <> n.maturity
        or o.overdueinterest <> n.overdueinterest
        or o.writeoffstatus <> n.writeoffstatus
        or o.remark <> n.remark
        or o.sex <> n.sex
        or o.balance <> n.balance
        or o.billtype <> n.billtype
        or o.migtflag <> n.migtflag
        or o.businesssum <> n.businesssum
        or o.repaytype <> n.repaytype
        or o.loansum <> n.loansum
        or o.businesstype <> n.businesstype
        or o.actlwriteoffloanprcp <> n.actlwriteoffloanprcp
        or o.fiveriskcla <> n.fiveriskcla
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_afterloan_write_off_duebill_cl(
            bdserialno -- 借据编号
            ,overduedays -- 逾期天数
            ,certtype -- 证件类型
            ,actlwriteoffinint -- 核销表内利息
            ,collectionnum -- 催收次数
            ,writeoffdate -- 指该贷款首次的核销日期。
            ,capitalpenaltybalance -- 罚息
            ,filepath -- 文件路径
            ,inboundbatno -- 入库批次号
            ,enddate -- 贷款逾期日
            ,actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
            ,advancepayment -- 核销垫付费用
            ,certid -- 证件号码
            ,executerate -- 执行年利率
            ,termmonth -- 期限
            ,startdate -- 贷款发放日
            ,loanbalance -- 存款余额
            ,inbounddate -- 入库日期
            ,customerid -- 客户编号
            ,finabrid -- 账务机构
            ,customername -- 客户名称
            ,maturity -- 借据到期日
            ,overdueinterest -- 利息
            ,writeoffstatus -- 核销状态
            ,remark -- 备注
            ,sex -- 性别
            ,balance -- 借据余额
            ,billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businesssum -- 借据金额
            ,repaytype -- 还款方式
            ,loansum -- 贷款余额
            ,businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
            ,actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
            ,fiveriskcla -- 五级风险分类
            ,updatedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_afterloan_write_off_duebill_op(
            bdserialno -- 借据编号
            ,overduedays -- 逾期天数
            ,certtype -- 证件类型
            ,actlwriteoffinint -- 核销表内利息
            ,collectionnum -- 催收次数
            ,writeoffdate -- 指该贷款首次的核销日期。
            ,capitalpenaltybalance -- 罚息
            ,filepath -- 文件路径
            ,inboundbatno -- 入库批次号
            ,enddate -- 贷款逾期日
            ,actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
            ,advancepayment -- 核销垫付费用
            ,certid -- 证件号码
            ,executerate -- 执行年利率
            ,termmonth -- 期限
            ,startdate -- 贷款发放日
            ,loanbalance -- 存款余额
            ,inbounddate -- 入库日期
            ,customerid -- 客户编号
            ,finabrid -- 账务机构
            ,customername -- 客户名称
            ,maturity -- 借据到期日
            ,overdueinterest -- 利息
            ,writeoffstatus -- 核销状态
            ,remark -- 备注
            ,sex -- 性别
            ,balance -- 借据余额
            ,billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businesssum -- 借据金额
            ,repaytype -- 还款方式
            ,loansum -- 贷款余额
            ,businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
            ,actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
            ,fiveriskcla -- 五级风险分类
            ,updatedate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bdserialno -- 借据编号
    ,o.overduedays -- 逾期天数
    ,o.certtype -- 证件类型
    ,o.actlwriteoffinint -- 核销表内利息
    ,o.collectionnum -- 催收次数
    ,o.writeoffdate -- 指该贷款首次的核销日期。
    ,o.capitalpenaltybalance -- 罚息
    ,o.filepath -- 文件路径
    ,o.inboundbatno -- 入库批次号
    ,o.enddate -- 贷款逾期日
    ,o.actlwriteoffoffint -- 指银行贷款核销时应收回表外利息
    ,o.advancepayment -- 核销垫付费用
    ,o.certid -- 证件号码
    ,o.executerate -- 执行年利率
    ,o.termmonth -- 期限
    ,o.startdate -- 贷款发放日
    ,o.loanbalance -- 存款余额
    ,o.inbounddate -- 入库日期
    ,o.customerid -- 客户编号
    ,o.finabrid -- 账务机构
    ,o.customername -- 客户名称
    ,o.maturity -- 借据到期日
    ,o.overdueinterest -- 利息
    ,o.writeoffstatus -- 核销状态
    ,o.remark -- 备注
    ,o.sex -- 性别
    ,o.balance -- 借据余额
    ,o.billtype -- 借据类型（1-自营贷款2-互联网自营贷款3-互联网联合贷款）
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.businesssum -- 借据金额
    ,o.repaytype -- 还款方式
    ,o.loansum -- 贷款余额
    ,o.businesstype -- 业务类型:1借呗二期2借呗三期3花呗4网商贷
    ,o.actlwriteoffloanprcp -- 指银行贷款核销时应收回本金
    ,o.fiveriskcla -- 五级风险分类
    ,o.updatedate -- 
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
from ${iol_schema}.icms_afterloan_write_off_duebill_bk o
    left join ${iol_schema}.icms_afterloan_write_off_duebill_op n
        on
            o.bdserialno = n.bdserialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_afterloan_write_off_duebill_cl d
        on
            o.bdserialno = d.bdserialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_afterloan_write_off_duebill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_afterloan_write_off_duebill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_afterloan_write_off_duebill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_afterloan_write_off_duebill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_afterloan_write_off_duebill exchange partition p_${batch_date} with table ${iol_schema}.icms_afterloan_write_off_duebill_cl;
alter table ${iol_schema}.icms_afterloan_write_off_duebill exchange partition p_20991231 with table ${iol_schema}.icms_afterloan_write_off_duebill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_afterloan_write_off_duebill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_afterloan_write_off_duebill_op purge;
drop table ${iol_schema}.icms_afterloan_write_off_duebill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_afterloan_write_off_duebill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_afterloan_write_off_duebill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
