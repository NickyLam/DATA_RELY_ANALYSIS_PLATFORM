/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_extension
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
create table ${iol_schema}.icms_business_extension_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_extension
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_extension_op purge;
drop table ${iol_schema}.icms_business_extension_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_extension_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_extension where 0=1;

create table ${iol_schema}.icms_business_extension_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_extension where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_extension_cl(
            serialno -- 信息流水号
            ,occurtime -- 发生时间
            ,transactionflag -- 交易标志
            ,voucherno -- 凭证号码
            ,overduefloat -- 逾期贷款利率浮动比例
            ,extendflag -- 更新标志
            ,rategenre -- 利率重定价
            ,occurdate -- 发生日期
            ,extendtermday -- 展期期限日
            ,orgid -- 创建机构
            ,ratefloat -- (Del)浮动利率
            ,lastmaturity -- 原到期日
            ,putoutno -- 出帐号
            ,relativeduebillno -- 关联借据号
            ,extendtermmonth -- 展期期限月
            ,extendrate -- 展期利率
            ,lastrate -- 原利率
            ,extensionsum -- 展期金额
            ,overduerate -- 逾期贷款执行利率
            ,contractno -- 展期合同号
            ,extendtermyear -- 展期期限年
            ,baserate -- (Del)基准利率
            ,lastputoutdate -- 展期前起始日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessrate -- 利率
            ,userid -- 操作员
            ,extendputoutdate -- 受托支付序号
            ,baseratetype -- (Del)基准利率类型
            ,lastsum -- 展期前金额
            ,extendmaturity -- 展期后到期日
            ,remark -- 备注
            ,rateadjustfrequency -- 利率调整周期
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,orderno -- 预约编号
            ,nextsettlementdate -- 
            ,extendeffectdate -- 
            ,extendrateeffectdate -- 
            ,extendrepayplaneffectdate -- 
            ,newrepaytype -- 
            ,finalmerger -- 
            ,repaydate -- 
            ,repaycycle -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_extension_op(
            serialno -- 信息流水号
            ,occurtime -- 发生时间
            ,transactionflag -- 交易标志
            ,voucherno -- 凭证号码
            ,overduefloat -- 逾期贷款利率浮动比例
            ,extendflag -- 更新标志
            ,rategenre -- 利率重定价
            ,occurdate -- 发生日期
            ,extendtermday -- 展期期限日
            ,orgid -- 创建机构
            ,ratefloat -- (Del)浮动利率
            ,lastmaturity -- 原到期日
            ,putoutno -- 出帐号
            ,relativeduebillno -- 关联借据号
            ,extendtermmonth -- 展期期限月
            ,extendrate -- 展期利率
            ,lastrate -- 原利率
            ,extensionsum -- 展期金额
            ,overduerate -- 逾期贷款执行利率
            ,contractno -- 展期合同号
            ,extendtermyear -- 展期期限年
            ,baserate -- (Del)基准利率
            ,lastputoutdate -- 展期前起始日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessrate -- 利率
            ,userid -- 操作员
            ,extendputoutdate -- 受托支付序号
            ,baseratetype -- (Del)基准利率类型
            ,lastsum -- 展期前金额
            ,extendmaturity -- 展期后到期日
            ,remark -- 备注
            ,rateadjustfrequency -- 利率调整周期
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,orderno -- 预约编号
            ,nextsettlementdate -- 
            ,extendeffectdate -- 
            ,extendrateeffectdate -- 
            ,extendrepayplaneffectdate -- 
            ,newrepaytype -- 
            ,finalmerger -- 
            ,repaydate -- 
            ,repaycycle -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 信息流水号
    ,nvl(n.occurtime, o.occurtime) as occurtime -- 发生时间
    ,nvl(n.transactionflag, o.transactionflag) as transactionflag -- 交易标志
    ,nvl(n.voucherno, o.voucherno) as voucherno -- 凭证号码
    ,nvl(n.overduefloat, o.overduefloat) as overduefloat -- 逾期贷款利率浮动比例
    ,nvl(n.extendflag, o.extendflag) as extendflag -- 更新标志
    ,nvl(n.rategenre, o.rategenre) as rategenre -- 利率重定价
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 发生日期
    ,nvl(n.extendtermday, o.extendtermday) as extendtermday -- 展期期限日
    ,nvl(n.orgid, o.orgid) as orgid -- 创建机构
    ,nvl(n.ratefloat, o.ratefloat) as ratefloat -- (Del)浮动利率
    ,nvl(n.lastmaturity, o.lastmaturity) as lastmaturity -- 原到期日
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出帐号
    ,nvl(n.relativeduebillno, o.relativeduebillno) as relativeduebillno -- 关联借据号
    ,nvl(n.extendtermmonth, o.extendtermmonth) as extendtermmonth -- 展期期限月
    ,nvl(n.extendrate, o.extendrate) as extendrate -- 展期利率
    ,nvl(n.lastrate, o.lastrate) as lastrate -- 原利率
    ,nvl(n.extensionsum, o.extensionsum) as extensionsum -- 展期金额
    ,nvl(n.overduerate, o.overduerate) as overduerate -- 逾期贷款执行利率
    ,nvl(n.contractno, o.contractno) as contractno -- 展期合同号
    ,nvl(n.extendtermyear, o.extendtermyear) as extendtermyear -- 展期期限年
    ,nvl(n.baserate, o.baserate) as baserate -- (Del)基准利率
    ,nvl(n.lastputoutdate, o.lastputoutdate) as lastputoutdate -- 展期前起始日
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.businessrate, o.businessrate) as businessrate -- 利率
    ,nvl(n.userid, o.userid) as userid -- 操作员
    ,nvl(n.extendputoutdate, o.extendputoutdate) as extendputoutdate -- 受托支付序号
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- (Del)基准利率类型
    ,nvl(n.lastsum, o.lastsum) as lastsum -- 展期前金额
    ,nvl(n.extendmaturity, o.extendmaturity) as extendmaturity -- 展期后到期日
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rateadjustfrequency, o.rateadjustfrequency) as rateadjustfrequency -- 利率调整周期
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,nvl(n.orderno, o.orderno) as orderno -- 预约编号
    ,nvl(n.nextsettlementdate, o.nextsettlementdate) as nextsettlementdate -- 
    ,nvl(n.extendeffectdate, o.extendeffectdate) as extendeffectdate -- 
    ,nvl(n.extendrateeffectdate, o.extendrateeffectdate) as extendrateeffectdate -- 
    ,nvl(n.extendrepayplaneffectdate, o.extendrepayplaneffectdate) as extendrepayplaneffectdate -- 
    ,nvl(n.newrepaytype, o.newrepaytype) as newrepaytype -- 
    ,nvl(n.finalmerger, o.finalmerger) as finalmerger -- 
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 
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
from (select * from ${iol_schema}.icms_business_extension_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_extension where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.occurtime <> n.occurtime
        or o.transactionflag <> n.transactionflag
        or o.voucherno <> n.voucherno
        or o.overduefloat <> n.overduefloat
        or o.extendflag <> n.extendflag
        or o.rategenre <> n.rategenre
        or o.occurdate <> n.occurdate
        or o.extendtermday <> n.extendtermday
        or o.orgid <> n.orgid
        or o.ratefloat <> n.ratefloat
        or o.lastmaturity <> n.lastmaturity
        or o.putoutno <> n.putoutno
        or o.relativeduebillno <> n.relativeduebillno
        or o.extendtermmonth <> n.extendtermmonth
        or o.extendrate <> n.extendrate
        or o.lastrate <> n.lastrate
        or o.extensionsum <> n.extensionsum
        or o.overduerate <> n.overduerate
        or o.contractno <> n.contractno
        or o.extendtermyear <> n.extendtermyear
        or o.baserate <> n.baserate
        or o.lastputoutdate <> n.lastputoutdate
        or o.migtflag <> n.migtflag
        or o.businessrate <> n.businessrate
        or o.userid <> n.userid
        or o.extendputoutdate <> n.extendputoutdate
        or o.baseratetype <> n.baseratetype
        or o.lastsum <> n.lastsum
        or o.extendmaturity <> n.extendmaturity
        or o.remark <> n.remark
        or o.rateadjustfrequency <> n.rateadjustfrequency
        or o.rateadjusttype <> n.rateadjusttype
        or o.orderno <> n.orderno
        or o.nextsettlementdate <> n.nextsettlementdate
        or o.extendeffectdate <> n.extendeffectdate
        or o.extendrateeffectdate <> n.extendrateeffectdate
        or o.extendrepayplaneffectdate <> n.extendrepayplaneffectdate
        or o.newrepaytype <> n.newrepaytype
        or o.finalmerger <> n.finalmerger
        or o.repaydate <> n.repaydate
        or o.repaycycle <> n.repaycycle
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_extension_cl(
            serialno -- 信息流水号
            ,occurtime -- 发生时间
            ,transactionflag -- 交易标志
            ,voucherno -- 凭证号码
            ,overduefloat -- 逾期贷款利率浮动比例
            ,extendflag -- 更新标志
            ,rategenre -- 利率重定价
            ,occurdate -- 发生日期
            ,extendtermday -- 展期期限日
            ,orgid -- 创建机构
            ,ratefloat -- (Del)浮动利率
            ,lastmaturity -- 原到期日
            ,putoutno -- 出帐号
            ,relativeduebillno -- 关联借据号
            ,extendtermmonth -- 展期期限月
            ,extendrate -- 展期利率
            ,lastrate -- 原利率
            ,extensionsum -- 展期金额
            ,overduerate -- 逾期贷款执行利率
            ,contractno -- 展期合同号
            ,extendtermyear -- 展期期限年
            ,baserate -- (Del)基准利率
            ,lastputoutdate -- 展期前起始日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessrate -- 利率
            ,userid -- 操作员
            ,extendputoutdate -- 受托支付序号
            ,baseratetype -- (Del)基准利率类型
            ,lastsum -- 展期前金额
            ,extendmaturity -- 展期后到期日
            ,remark -- 备注
            ,rateadjustfrequency -- 利率调整周期
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,orderno -- 预约编号
            ,nextsettlementdate -- 
            ,extendeffectdate -- 
            ,extendrateeffectdate -- 
            ,extendrepayplaneffectdate -- 
            ,newrepaytype -- 
            ,finalmerger -- 
            ,repaydate -- 
            ,repaycycle -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_extension_op(
            serialno -- 信息流水号
            ,occurtime -- 发生时间
            ,transactionflag -- 交易标志
            ,voucherno -- 凭证号码
            ,overduefloat -- 逾期贷款利率浮动比例
            ,extendflag -- 更新标志
            ,rategenre -- 利率重定价
            ,occurdate -- 发生日期
            ,extendtermday -- 展期期限日
            ,orgid -- 创建机构
            ,ratefloat -- (Del)浮动利率
            ,lastmaturity -- 原到期日
            ,putoutno -- 出帐号
            ,relativeduebillno -- 关联借据号
            ,extendtermmonth -- 展期期限月
            ,extendrate -- 展期利率
            ,lastrate -- 原利率
            ,extensionsum -- 展期金额
            ,overduerate -- 逾期贷款执行利率
            ,contractno -- 展期合同号
            ,extendtermyear -- 展期期限年
            ,baserate -- (Del)基准利率
            ,lastputoutdate -- 展期前起始日
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,businessrate -- 利率
            ,userid -- 操作员
            ,extendputoutdate -- 受托支付序号
            ,baseratetype -- (Del)基准利率类型
            ,lastsum -- 展期前金额
            ,extendmaturity -- 展期后到期日
            ,remark -- 备注
            ,rateadjustfrequency -- 利率调整周期
            ,rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
            ,orderno -- 预约编号
            ,nextsettlementdate -- 
            ,extendeffectdate -- 
            ,extendrateeffectdate -- 
            ,extendrepayplaneffectdate -- 
            ,newrepaytype -- 
            ,finalmerger -- 
            ,repaydate -- 
            ,repaycycle -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 信息流水号
    ,o.occurtime -- 发生时间
    ,o.transactionflag -- 交易标志
    ,o.voucherno -- 凭证号码
    ,o.overduefloat -- 逾期贷款利率浮动比例
    ,o.extendflag -- 更新标志
    ,o.rategenre -- 利率重定价
    ,o.occurdate -- 发生日期
    ,o.extendtermday -- 展期期限日
    ,o.orgid -- 创建机构
    ,o.ratefloat -- (Del)浮动利率
    ,o.lastmaturity -- 原到期日
    ,o.putoutno -- 出帐号
    ,o.relativeduebillno -- 关联借据号
    ,o.extendtermmonth -- 展期期限月
    ,o.extendrate -- 展期利率
    ,o.lastrate -- 原利率
    ,o.extensionsum -- 展期金额
    ,o.overduerate -- 逾期贷款执行利率
    ,o.contractno -- 展期合同号
    ,o.extendtermyear -- 展期期限年
    ,o.baserate -- (Del)基准利率
    ,o.lastputoutdate -- 展期前起始日
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.businessrate -- 利率
    ,o.userid -- 操作员
    ,o.extendputoutdate -- 受托支付序号
    ,o.baseratetype -- (Del)基准利率类型
    ,o.lastsum -- 展期前金额
    ,o.extendmaturity -- 展期后到期日
    ,o.remark -- 备注
    ,o.rateadjustfrequency -- 利率调整周期
    ,o.rateadjusttype -- 利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
    ,o.orderno -- 预约编号
    ,o.nextsettlementdate -- 
    ,o.extendeffectdate -- 
    ,o.extendrateeffectdate -- 
    ,o.extendrepayplaneffectdate -- 
    ,o.newrepaytype -- 
    ,o.finalmerger -- 
    ,o.repaydate -- 
    ,o.repaycycle -- 
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
from ${iol_schema}.icms_business_extension_bk o
    left join ${iol_schema}.icms_business_extension_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_extension_cl d
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
--truncate table ${iol_schema}.icms_business_extension;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_extension') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_extension drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_extension add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_extension exchange partition p_${batch_date} with table ${iol_schema}.icms_business_extension_cl;
alter table ${iol_schema}.icms_business_extension exchange partition p_20991231 with table ${iol_schema}.icms_business_extension_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_extension to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_extension_op purge;
drop table ${iol_schema}.icms_business_extension_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_extension_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_extension',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
