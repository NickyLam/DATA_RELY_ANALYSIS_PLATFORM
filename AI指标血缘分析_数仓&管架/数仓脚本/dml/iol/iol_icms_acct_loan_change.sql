/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_loan_change
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
create table ${iol_schema}.icms_acct_loan_change_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_acct_loan_change
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_loan_change_op purge;
drop table ${iol_schema}.icms_acct_loan_change_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_loan_change_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_loan_change where 0=1;

create table ${iol_schema}.icms_acct_loan_change_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_loan_change where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_loan_change_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,maturitydate -- 新贷款到期日
            ,oldmaturitydate -- 原贷款到期日
            ,loantermunit -- 新贷款期限单位
            ,loanterm -- 新贷款期限
            ,oldloantermunit -- 原贷款期限单位
            ,oldloanterm -- 原贷款期限
            ,accountingorgid -- 新贷款账务机构
            ,oldaccountingorgid -- 旧贷款账务机构
            ,remark -- 备注
            ,defaultdueday -- 默认还款日
            ,ratechangeflag -- 变更标志
            ,olddefaultdueday -- 原默认还款日
            ,fbfromdate -- 回退前日期
            ,fbtodate -- 回退至日期
            ,revertflag -- 恢复标示（ 0,待恢复,1,已恢复）
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,attribute9 -- 属性9
            ,attribute10 -- 属性10
            ,attribute11 -- 属性11
            ,accruedate -- 属性
            ,accountno -- 买入方存款账号
            ,attribute12 -- 属性12
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,attribute13 -- 属性13
            ,attribute14 -- 属性14
            ,attribute15 -- 属性15
            ,attribute16 -- 属性16
            ,attribute17 -- 属性17
            ,attribute18 -- 属性18
            ,attribute19 -- 属性19
            ,attribute20 -- 属性20
            ,attribute21 -- 属性21
            ,attribute22 -- 属性22
            ,attribute23 -- 属性23
            ,attribute24 -- 属性24
            ,attribute25 -- 属性25
            ,attribute26 -- 属性26
            ,finalmerger -- 是否末期合并：0否，1是
            ,attribute27 -- 属性27
            ,attribute28 -- 属性28
            ,attribute29 -- 属性29
            ,attribute30 -- 属性30
            ,attribute31 -- 属性31
            ,attribute32 -- 属性32
            ,attribute33 -- 属性33
            ,transferinterest -- 是否转利息
            ,termchangetype -- 期限变更类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_loan_change_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,maturitydate -- 新贷款到期日
            ,oldmaturitydate -- 原贷款到期日
            ,loantermunit -- 新贷款期限单位
            ,loanterm -- 新贷款期限
            ,oldloantermunit -- 原贷款期限单位
            ,oldloanterm -- 原贷款期限
            ,accountingorgid -- 新贷款账务机构
            ,oldaccountingorgid -- 旧贷款账务机构
            ,remark -- 备注
            ,defaultdueday -- 默认还款日
            ,ratechangeflag -- 变更标志
            ,olddefaultdueday -- 原默认还款日
            ,fbfromdate -- 回退前日期
            ,fbtodate -- 回退至日期
            ,revertflag -- 恢复标示（ 0,待恢复,1,已恢复）
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,attribute9 -- 属性9
            ,attribute10 -- 属性10
            ,attribute11 -- 属性11
            ,accruedate -- 属性
            ,accountno -- 买入方存款账号
            ,attribute12 -- 属性12
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,attribute13 -- 属性13
            ,attribute14 -- 属性14
            ,attribute15 -- 属性15
            ,attribute16 -- 属性16
            ,attribute17 -- 属性17
            ,attribute18 -- 属性18
            ,attribute19 -- 属性19
            ,attribute20 -- 属性20
            ,attribute21 -- 属性21
            ,attribute22 -- 属性22
            ,attribute23 -- 属性23
            ,attribute24 -- 属性24
            ,attribute25 -- 属性25
            ,attribute26 -- 属性26
            ,finalmerger -- 是否末期合并：0否，1是
            ,attribute27 -- 属性27
            ,attribute28 -- 属性28
            ,attribute29 -- 属性29
            ,attribute30 -- 属性30
            ,attribute31 -- 属性31
            ,attribute32 -- 属性32
            ,attribute33 -- 属性33
            ,transferinterest -- 是否转利息
            ,termchangetype -- 期限变更类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.maturitydate, o.maturitydate) as maturitydate -- 新贷款到期日
    ,nvl(n.oldmaturitydate, o.oldmaturitydate) as oldmaturitydate -- 原贷款到期日
    ,nvl(n.loantermunit, o.loantermunit) as loantermunit -- 新贷款期限单位
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 新贷款期限
    ,nvl(n.oldloantermunit, o.oldloantermunit) as oldloantermunit -- 原贷款期限单位
    ,nvl(n.oldloanterm, o.oldloanterm) as oldloanterm -- 原贷款期限
    ,nvl(n.accountingorgid, o.accountingorgid) as accountingorgid -- 新贷款账务机构
    ,nvl(n.oldaccountingorgid, o.oldaccountingorgid) as oldaccountingorgid -- 旧贷款账务机构
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.defaultdueday, o.defaultdueday) as defaultdueday -- 默认还款日
    ,nvl(n.ratechangeflag, o.ratechangeflag) as ratechangeflag -- 变更标志
    ,nvl(n.olddefaultdueday, o.olddefaultdueday) as olddefaultdueday -- 原默认还款日
    ,nvl(n.fbfromdate, o.fbfromdate) as fbfromdate -- 回退前日期
    ,nvl(n.fbtodate, o.fbtodate) as fbtodate -- 回退至日期
    ,nvl(n.revertflag, o.revertflag) as revertflag -- 恢复标示（ 0,待恢复,1,已恢复）
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 属性4
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 属性5
    ,nvl(n.attribute6, o.attribute6) as attribute6 -- 属性6
    ,nvl(n.attribute7, o.attribute7) as attribute7 -- 属性7
    ,nvl(n.attribute8, o.attribute8) as attribute8 -- 属性8
    ,nvl(n.attribute9, o.attribute9) as attribute9 -- 属性9
    ,nvl(n.attribute10, o.attribute10) as attribute10 -- 属性10
    ,nvl(n.attribute11, o.attribute11) as attribute11 -- 属性11
    ,nvl(n.accruedate, o.accruedate) as accruedate -- 属性
    ,nvl(n.accountno, o.accountno) as accountno -- 买入方存款账号
    ,nvl(n.attribute12, o.attribute12) as attribute12 -- 属性12
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：CRS RCR ILC UPL
    ,nvl(n.attribute13, o.attribute13) as attribute13 -- 属性13
    ,nvl(n.attribute14, o.attribute14) as attribute14 -- 属性14
    ,nvl(n.attribute15, o.attribute15) as attribute15 -- 属性15
    ,nvl(n.attribute16, o.attribute16) as attribute16 -- 属性16
    ,nvl(n.attribute17, o.attribute17) as attribute17 -- 属性17
    ,nvl(n.attribute18, o.attribute18) as attribute18 -- 属性18
    ,nvl(n.attribute19, o.attribute19) as attribute19 -- 属性19
    ,nvl(n.attribute20, o.attribute20) as attribute20 -- 属性20
    ,nvl(n.attribute21, o.attribute21) as attribute21 -- 属性21
    ,nvl(n.attribute22, o.attribute22) as attribute22 -- 属性22
    ,nvl(n.attribute23, o.attribute23) as attribute23 -- 属性23
    ,nvl(n.attribute24, o.attribute24) as attribute24 -- 属性24
    ,nvl(n.attribute25, o.attribute25) as attribute25 -- 属性25
    ,nvl(n.attribute26, o.attribute26) as attribute26 -- 属性26
    ,nvl(n.finalmerger, o.finalmerger) as finalmerger -- 是否末期合并：0否，1是
    ,nvl(n.attribute27, o.attribute27) as attribute27 -- 属性27
    ,nvl(n.attribute28, o.attribute28) as attribute28 -- 属性28
    ,nvl(n.attribute29, o.attribute29) as attribute29 -- 属性29
    ,nvl(n.attribute30, o.attribute30) as attribute30 -- 属性30
    ,nvl(n.attribute31, o.attribute31) as attribute31 -- 属性31
    ,nvl(n.attribute32, o.attribute32) as attribute32 -- 属性32
    ,nvl(n.attribute33, o.attribute33) as attribute33 -- 属性33
    ,nvl(n.transferinterest, o.transferinterest) as transferinterest -- 是否转利息
    ,nvl(n.termchangetype, o.termchangetype) as termchangetype -- 期限变更类型
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
from (select * from ${iol_schema}.icms_acct_loan_change_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_acct_loan_change where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.maturitydate <> n.maturitydate
        or o.oldmaturitydate <> n.oldmaturitydate
        or o.loantermunit <> n.loantermunit
        or o.loanterm <> n.loanterm
        or o.oldloantermunit <> n.oldloantermunit
        or o.oldloanterm <> n.oldloanterm
        or o.accountingorgid <> n.accountingorgid
        or o.oldaccountingorgid <> n.oldaccountingorgid
        or o.remark <> n.remark
        or o.defaultdueday <> n.defaultdueday
        or o.ratechangeflag <> n.ratechangeflag
        or o.olddefaultdueday <> n.olddefaultdueday
        or o.fbfromdate <> n.fbfromdate
        or o.fbtodate <> n.fbtodate
        or o.revertflag <> n.revertflag
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute4 <> n.attribute4
        or o.attribute5 <> n.attribute5
        or o.attribute6 <> n.attribute6
        or o.attribute7 <> n.attribute7
        or o.attribute8 <> n.attribute8
        or o.attribute9 <> n.attribute9
        or o.attribute10 <> n.attribute10
        or o.attribute11 <> n.attribute11
        or o.accruedate <> n.accruedate
        or o.accountno <> n.accountno
        or o.attribute12 <> n.attribute12
        or o.migtflag <> n.migtflag
        or o.attribute13 <> n.attribute13
        or o.attribute14 <> n.attribute14
        or o.attribute15 <> n.attribute15
        or o.attribute16 <> n.attribute16
        or o.attribute17 <> n.attribute17
        or o.attribute18 <> n.attribute18
        or o.attribute19 <> n.attribute19
        or o.attribute20 <> n.attribute20
        or o.attribute21 <> n.attribute21
        or o.attribute22 <> n.attribute22
        or o.attribute23 <> n.attribute23
        or o.attribute24 <> n.attribute24
        or o.attribute25 <> n.attribute25
        or o.attribute26 <> n.attribute26
        or o.finalmerger <> n.finalmerger
        or o.attribute27 <> n.attribute27
        or o.attribute28 <> n.attribute28
        or o.attribute29 <> n.attribute29
        or o.attribute30 <> n.attribute30
        or o.attribute31 <> n.attribute31
        or o.attribute32 <> n.attribute32
        or o.attribute33 <> n.attribute33
        or o.transferinterest <> n.transferinterest
        or o.termchangetype <> n.termchangetype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_loan_change_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,maturitydate -- 新贷款到期日
            ,oldmaturitydate -- 原贷款到期日
            ,loantermunit -- 新贷款期限单位
            ,loanterm -- 新贷款期限
            ,oldloantermunit -- 原贷款期限单位
            ,oldloanterm -- 原贷款期限
            ,accountingorgid -- 新贷款账务机构
            ,oldaccountingorgid -- 旧贷款账务机构
            ,remark -- 备注
            ,defaultdueday -- 默认还款日
            ,ratechangeflag -- 变更标志
            ,olddefaultdueday -- 原默认还款日
            ,fbfromdate -- 回退前日期
            ,fbtodate -- 回退至日期
            ,revertflag -- 恢复标示（ 0,待恢复,1,已恢复）
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,attribute9 -- 属性9
            ,attribute10 -- 属性10
            ,attribute11 -- 属性11
            ,accruedate -- 属性
            ,accountno -- 买入方存款账号
            ,attribute12 -- 属性12
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,attribute13 -- 属性13
            ,attribute14 -- 属性14
            ,attribute15 -- 属性15
            ,attribute16 -- 属性16
            ,attribute17 -- 属性17
            ,attribute18 -- 属性18
            ,attribute19 -- 属性19
            ,attribute20 -- 属性20
            ,attribute21 -- 属性21
            ,attribute22 -- 属性22
            ,attribute23 -- 属性23
            ,attribute24 -- 属性24
            ,attribute25 -- 属性25
            ,attribute26 -- 属性26
            ,finalmerger -- 是否末期合并：0否，1是
            ,attribute27 -- 属性27
            ,attribute28 -- 属性28
            ,attribute29 -- 属性29
            ,attribute30 -- 属性30
            ,attribute31 -- 属性31
            ,attribute32 -- 属性32
            ,attribute33 -- 属性33
            ,transferinterest -- 是否转利息
            ,termchangetype -- 期限变更类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_loan_change_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,maturitydate -- 新贷款到期日
            ,oldmaturitydate -- 原贷款到期日
            ,loantermunit -- 新贷款期限单位
            ,loanterm -- 新贷款期限
            ,oldloantermunit -- 原贷款期限单位
            ,oldloanterm -- 原贷款期限
            ,accountingorgid -- 新贷款账务机构
            ,oldaccountingorgid -- 旧贷款账务机构
            ,remark -- 备注
            ,defaultdueday -- 默认还款日
            ,ratechangeflag -- 变更标志
            ,olddefaultdueday -- 原默认还款日
            ,fbfromdate -- 回退前日期
            ,fbtodate -- 回退至日期
            ,revertflag -- 恢复标示（ 0,待恢复,1,已恢复）
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute4 -- 属性4
            ,attribute5 -- 属性5
            ,attribute6 -- 属性6
            ,attribute7 -- 属性7
            ,attribute8 -- 属性8
            ,attribute9 -- 属性9
            ,attribute10 -- 属性10
            ,attribute11 -- 属性11
            ,accruedate -- 属性
            ,accountno -- 买入方存款账号
            ,attribute12 -- 属性12
            ,migtflag -- 迁移标志：CRS RCR ILC UPL
            ,attribute13 -- 属性13
            ,attribute14 -- 属性14
            ,attribute15 -- 属性15
            ,attribute16 -- 属性16
            ,attribute17 -- 属性17
            ,attribute18 -- 属性18
            ,attribute19 -- 属性19
            ,attribute20 -- 属性20
            ,attribute21 -- 属性21
            ,attribute22 -- 属性22
            ,attribute23 -- 属性23
            ,attribute24 -- 属性24
            ,attribute25 -- 属性25
            ,attribute26 -- 属性26
            ,finalmerger -- 是否末期合并：0否，1是
            ,attribute27 -- 属性27
            ,attribute28 -- 属性28
            ,attribute29 -- 属性29
            ,attribute30 -- 属性30
            ,attribute31 -- 属性31
            ,attribute32 -- 属性32
            ,attribute33 -- 属性33
            ,transferinterest -- 是否转利息
            ,termchangetype -- 期限变更类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.maturitydate -- 新贷款到期日
    ,o.oldmaturitydate -- 原贷款到期日
    ,o.loantermunit -- 新贷款期限单位
    ,o.loanterm -- 新贷款期限
    ,o.oldloantermunit -- 原贷款期限单位
    ,o.oldloanterm -- 原贷款期限
    ,o.accountingorgid -- 新贷款账务机构
    ,o.oldaccountingorgid -- 旧贷款账务机构
    ,o.remark -- 备注
    ,o.defaultdueday -- 默认还款日
    ,o.ratechangeflag -- 变更标志
    ,o.olddefaultdueday -- 原默认还款日
    ,o.fbfromdate -- 回退前日期
    ,o.fbtodate -- 回退至日期
    ,o.revertflag -- 恢复标示（ 0,待恢复,1,已恢复）
    ,o.attribute1 -- 属性1
    ,o.attribute2 -- 属性2
    ,o.attribute3 -- 属性3
    ,o.attribute4 -- 属性4
    ,o.attribute5 -- 属性5
    ,o.attribute6 -- 属性6
    ,o.attribute7 -- 属性7
    ,o.attribute8 -- 属性8
    ,o.attribute9 -- 属性9
    ,o.attribute10 -- 属性10
    ,o.attribute11 -- 属性11
    ,o.accruedate -- 属性
    ,o.accountno -- 买入方存款账号
    ,o.attribute12 -- 属性12
    ,o.migtflag -- 迁移标志：CRS RCR ILC UPL
    ,o.attribute13 -- 属性13
    ,o.attribute14 -- 属性14
    ,o.attribute15 -- 属性15
    ,o.attribute16 -- 属性16
    ,o.attribute17 -- 属性17
    ,o.attribute18 -- 属性18
    ,o.attribute19 -- 属性19
    ,o.attribute20 -- 属性20
    ,o.attribute21 -- 属性21
    ,o.attribute22 -- 属性22
    ,o.attribute23 -- 属性23
    ,o.attribute24 -- 属性24
    ,o.attribute25 -- 属性25
    ,o.attribute26 -- 属性26
    ,o.finalmerger -- 是否末期合并：0否，1是
    ,o.attribute27 -- 属性27
    ,o.attribute28 -- 属性28
    ,o.attribute29 -- 属性29
    ,o.attribute30 -- 属性30
    ,o.attribute31 -- 属性31
    ,o.attribute32 -- 属性32
    ,o.attribute33 -- 属性33
    ,o.transferinterest -- 是否转利息
    ,o.termchangetype -- 期限变更类型
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
from ${iol_schema}.icms_acct_loan_change_bk o
    left join ${iol_schema}.icms_acct_loan_change_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_acct_loan_change_cl d
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
--truncate table ${iol_schema}.icms_acct_loan_change;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_acct_loan_change') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_acct_loan_change drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_acct_loan_change add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_acct_loan_change exchange partition p_${batch_date} with table ${iol_schema}.icms_acct_loan_change_cl;
alter table ${iol_schema}.icms_acct_loan_change exchange partition p_20991231 with table ${iol_schema}.icms_acct_loan_change_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_acct_loan_change to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_loan_change_op purge;
drop table ${iol_schema}.icms_acct_loan_change_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_acct_loan_change_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_acct_loan_change',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
