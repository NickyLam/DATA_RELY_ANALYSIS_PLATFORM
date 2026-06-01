/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wld_tm_account
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
create table ${iol_schema}.icms_wld_tm_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wld_tm_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_tm_account_op purge;
drop table ${iol_schema}.icms_wld_tm_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_tm_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_tm_account where 0=1;

create table ${iol_schema}.icms_wld_tm_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wld_tm_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_tm_account_cl(
            org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,custid -- 客户编号
            ,custlimitid -- 客户额度ID
            ,productcd -- 产品代码
            ,defaultlogicalcardno -- 默认逻辑卡号
            ,currcd -- 币种
            ,creditlimit -- 授信额度
            ,templimit -- 临时额度
            ,templimitbegindate -- 临时额度开始日期
            ,templimitenddate -- 临时额度结束日期
            ,currbal -- 当前余额
            ,principalbal -- 本金余额
            ,beginbal -- 上一到期日余额
            ,pmtduedaybal -- 到期还款日余额
            ,name -- 姓名
            ,gender -- 性别
            ,mobileno -- 移动电话
            ,billingcycle -- 还款日
            ,agecd -- 拖欠月数
            ,unmatchdb -- 未入账借记金额
            ,unmatchcr -- 未入账贷记金额
            ,ddind -- 约定还款类型
            ,ddbankname -- 约定还款银行名称
            ,ddbankbranch -- 约定还款开户行号
            ,ddbankacctno -- 约定还款扣款账号
            ,ddbankacctname -- 约定还款扣款账户姓名
            ,lastddamt -- 上期约定还款金额
            ,lastdddate -- 上期约定还款日期
            ,lastpmtamt -- 上笔还款金额
            ,lastpmtdate -- 上个还款日期
            ,laststmtdate -- 上个到期还款日期
            ,lastpmtduedate -- 上个到期还款日期
            ,lastagingdate -- 上个逾期月数提升日期
            ,collectdate -- 入催日期
            ,collectoutdate -- 出催收队列日期
            ,nextstmtdate -- 下个到期还款日期
            ,pmtduedate -- 到期还款日期
            ,dddate -- 约定还款日期
            ,gracedate -- 宽限日期
            ,closeddate -- 最终销户日期
            ,firststmtdate -- 首个到期还款日期
            ,canceldate -- 销户日期
            ,chargeoffdate -- 转呆账日期
            ,ctdretailamt -- 当期消费金额
            ,ctdretailcnt -- 当期消费笔数
            ,ctdpaymentamt -- 当期还款金额
            ,ctdpaymentcnt -- 当期还款笔数
            ,ctddbadjamt -- 当期借记调整金额
            ,ctddbadjcnt -- 当期借记调整笔数
            ,ctdcradjamt -- 当期贷记调整金额
            ,ctdcradjcnt -- 当期贷记调整笔数
            ,ctdfeeamt -- 当期费用金额
            ,ctdfeecnt -- 当期费用笔数
            ,ctdintegererestamt -- 当期利息金额
            ,ctdintegererestcnt -- 当期利息笔数
            ,mtdretailamt -- 本月消费金额
            ,mtdretailcnt -- 本月消费笔数
            ,ytdretailamt -- 本年消费金额
            ,ytdretailcnt -- 本年消费笔数
            ,waivesvcfeeind -- 是否免除服务费
            ,userdate2 -- 上次调额日期
            ,jpaversion -- 乐观锁版本号
            ,mtdpaymentamt -- 当月还款金额
            ,mtdpaymentcnt -- 当月还款笔数
            ,ytdpaymentamt -- 当年还款金额
            ,ytdpaymentcnt -- 当年还款笔数
            ,ltdpaymentamt -- 历史还款金额
            ,ltdpaymentcnt -- 历史还款笔数
            ,lastpostdate -- 上个批量处理日期
            ,lastsyncdate -- 上一次入账的批量日期
            ,bankgroupid -- 参贷方案编号
            ,bankproportion -- 银行出资比例
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_tm_account_op(
            org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,custid -- 客户编号
            ,custlimitid -- 客户额度ID
            ,productcd -- 产品代码
            ,defaultlogicalcardno -- 默认逻辑卡号
            ,currcd -- 币种
            ,creditlimit -- 授信额度
            ,templimit -- 临时额度
            ,templimitbegindate -- 临时额度开始日期
            ,templimitenddate -- 临时额度结束日期
            ,currbal -- 当前余额
            ,principalbal -- 本金余额
            ,beginbal -- 上一到期日余额
            ,pmtduedaybal -- 到期还款日余额
            ,name -- 姓名
            ,gender -- 性别
            ,mobileno -- 移动电话
            ,billingcycle -- 还款日
            ,agecd -- 拖欠月数
            ,unmatchdb -- 未入账借记金额
            ,unmatchcr -- 未入账贷记金额
            ,ddind -- 约定还款类型
            ,ddbankname -- 约定还款银行名称
            ,ddbankbranch -- 约定还款开户行号
            ,ddbankacctno -- 约定还款扣款账号
            ,ddbankacctname -- 约定还款扣款账户姓名
            ,lastddamt -- 上期约定还款金额
            ,lastdddate -- 上期约定还款日期
            ,lastpmtamt -- 上笔还款金额
            ,lastpmtdate -- 上个还款日期
            ,laststmtdate -- 上个到期还款日期
            ,lastpmtduedate -- 上个到期还款日期
            ,lastagingdate -- 上个逾期月数提升日期
            ,collectdate -- 入催日期
            ,collectoutdate -- 出催收队列日期
            ,nextstmtdate -- 下个到期还款日期
            ,pmtduedate -- 到期还款日期
            ,dddate -- 约定还款日期
            ,gracedate -- 宽限日期
            ,closeddate -- 最终销户日期
            ,firststmtdate -- 首个到期还款日期
            ,canceldate -- 销户日期
            ,chargeoffdate -- 转呆账日期
            ,ctdretailamt -- 当期消费金额
            ,ctdretailcnt -- 当期消费笔数
            ,ctdpaymentamt -- 当期还款金额
            ,ctdpaymentcnt -- 当期还款笔数
            ,ctddbadjamt -- 当期借记调整金额
            ,ctddbadjcnt -- 当期借记调整笔数
            ,ctdcradjamt -- 当期贷记调整金额
            ,ctdcradjcnt -- 当期贷记调整笔数
            ,ctdfeeamt -- 当期费用金额
            ,ctdfeecnt -- 当期费用笔数
            ,ctdintegererestamt -- 当期利息金额
            ,ctdintegererestcnt -- 当期利息笔数
            ,mtdretailamt -- 本月消费金额
            ,mtdretailcnt -- 本月消费笔数
            ,ytdretailamt -- 本年消费金额
            ,ytdretailcnt -- 本年消费笔数
            ,waivesvcfeeind -- 是否免除服务费
            ,userdate2 -- 上次调额日期
            ,jpaversion -- 乐观锁版本号
            ,mtdpaymentamt -- 当月还款金额
            ,mtdpaymentcnt -- 当月还款笔数
            ,ytdpaymentamt -- 当年还款金额
            ,ytdpaymentcnt -- 当年还款笔数
            ,ltdpaymentamt -- 历史还款金额
            ,ltdpaymentcnt -- 历史还款笔数
            ,lastpostdate -- 上个批量处理日期
            ,lastsyncdate -- 上一次入账的批量日期
            ,bankgroupid -- 参贷方案编号
            ,bankproportion -- 银行出资比例
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.acctno, o.acctno) as acctno -- 账户编号
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类型
    ,nvl(n.custid, o.custid) as custid -- 客户编号
    ,nvl(n.custlimitid, o.custlimitid) as custlimitid -- 客户额度ID
    ,nvl(n.productcd, o.productcd) as productcd -- 产品代码
    ,nvl(n.defaultlogicalcardno, o.defaultlogicalcardno) as defaultlogicalcardno -- 默认逻辑卡号
    ,nvl(n.currcd, o.currcd) as currcd -- 币种
    ,nvl(n.creditlimit, o.creditlimit) as creditlimit -- 授信额度
    ,nvl(n.templimit, o.templimit) as templimit -- 临时额度
    ,nvl(n.templimitbegindate, o.templimitbegindate) as templimitbegindate -- 临时额度开始日期
    ,nvl(n.templimitenddate, o.templimitenddate) as templimitenddate -- 临时额度结束日期
    ,nvl(n.currbal, o.currbal) as currbal -- 当前余额
    ,nvl(n.principalbal, o.principalbal) as principalbal -- 本金余额
    ,nvl(n.beginbal, o.beginbal) as beginbal -- 上一到期日余额
    ,nvl(n.pmtduedaybal, o.pmtduedaybal) as pmtduedaybal -- 到期还款日余额
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.mobileno, o.mobileno) as mobileno -- 移动电话
    ,nvl(n.billingcycle, o.billingcycle) as billingcycle -- 还款日
    ,nvl(n.agecd, o.agecd) as agecd -- 拖欠月数
    ,nvl(n.unmatchdb, o.unmatchdb) as unmatchdb -- 未入账借记金额
    ,nvl(n.unmatchcr, o.unmatchcr) as unmatchcr -- 未入账贷记金额
    ,nvl(n.ddind, o.ddind) as ddind -- 约定还款类型
    ,nvl(n.ddbankname, o.ddbankname) as ddbankname -- 约定还款银行名称
    ,nvl(n.ddbankbranch, o.ddbankbranch) as ddbankbranch -- 约定还款开户行号
    ,nvl(n.ddbankacctno, o.ddbankacctno) as ddbankacctno -- 约定还款扣款账号
    ,nvl(n.ddbankacctname, o.ddbankacctname) as ddbankacctname -- 约定还款扣款账户姓名
    ,nvl(n.lastddamt, o.lastddamt) as lastddamt -- 上期约定还款金额
    ,nvl(n.lastdddate, o.lastdddate) as lastdddate -- 上期约定还款日期
    ,nvl(n.lastpmtamt, o.lastpmtamt) as lastpmtamt -- 上笔还款金额
    ,nvl(n.lastpmtdate, o.lastpmtdate) as lastpmtdate -- 上个还款日期
    ,nvl(n.laststmtdate, o.laststmtdate) as laststmtdate -- 上个到期还款日期
    ,nvl(n.lastpmtduedate, o.lastpmtduedate) as lastpmtduedate -- 上个到期还款日期
    ,nvl(n.lastagingdate, o.lastagingdate) as lastagingdate -- 上个逾期月数提升日期
    ,nvl(n.collectdate, o.collectdate) as collectdate -- 入催日期
    ,nvl(n.collectoutdate, o.collectoutdate) as collectoutdate -- 出催收队列日期
    ,nvl(n.nextstmtdate, o.nextstmtdate) as nextstmtdate -- 下个到期还款日期
    ,nvl(n.pmtduedate, o.pmtduedate) as pmtduedate -- 到期还款日期
    ,nvl(n.dddate, o.dddate) as dddate -- 约定还款日期
    ,nvl(n.gracedate, o.gracedate) as gracedate -- 宽限日期
    ,nvl(n.closeddate, o.closeddate) as closeddate -- 最终销户日期
    ,nvl(n.firststmtdate, o.firststmtdate) as firststmtdate -- 首个到期还款日期
    ,nvl(n.canceldate, o.canceldate) as canceldate -- 销户日期
    ,nvl(n.chargeoffdate, o.chargeoffdate) as chargeoffdate -- 转呆账日期
    ,nvl(n.ctdretailamt, o.ctdretailamt) as ctdretailamt -- 当期消费金额
    ,nvl(n.ctdretailcnt, o.ctdretailcnt) as ctdretailcnt -- 当期消费笔数
    ,nvl(n.ctdpaymentamt, o.ctdpaymentamt) as ctdpaymentamt -- 当期还款金额
    ,nvl(n.ctdpaymentcnt, o.ctdpaymentcnt) as ctdpaymentcnt -- 当期还款笔数
    ,nvl(n.ctddbadjamt, o.ctddbadjamt) as ctddbadjamt -- 当期借记调整金额
    ,nvl(n.ctddbadjcnt, o.ctddbadjcnt) as ctddbadjcnt -- 当期借记调整笔数
    ,nvl(n.ctdcradjamt, o.ctdcradjamt) as ctdcradjamt -- 当期贷记调整金额
    ,nvl(n.ctdcradjcnt, o.ctdcradjcnt) as ctdcradjcnt -- 当期贷记调整笔数
    ,nvl(n.ctdfeeamt, o.ctdfeeamt) as ctdfeeamt -- 当期费用金额
    ,nvl(n.ctdfeecnt, o.ctdfeecnt) as ctdfeecnt -- 当期费用笔数
    ,nvl(n.ctdintegererestamt, o.ctdintegererestamt) as ctdintegererestamt -- 当期利息金额
    ,nvl(n.ctdintegererestcnt, o.ctdintegererestcnt) as ctdintegererestcnt -- 当期利息笔数
    ,nvl(n.mtdretailamt, o.mtdretailamt) as mtdretailamt -- 本月消费金额
    ,nvl(n.mtdretailcnt, o.mtdretailcnt) as mtdretailcnt -- 本月消费笔数
    ,nvl(n.ytdretailamt, o.ytdretailamt) as ytdretailamt -- 本年消费金额
    ,nvl(n.ytdretailcnt, o.ytdretailcnt) as ytdretailcnt -- 本年消费笔数
    ,nvl(n.waivesvcfeeind, o.waivesvcfeeind) as waivesvcfeeind -- 是否免除服务费
    ,nvl(n.userdate2, o.userdate2) as userdate2 -- 上次调额日期
    ,nvl(n.jpaversion, o.jpaversion) as jpaversion -- 乐观锁版本号
    ,nvl(n.mtdpaymentamt, o.mtdpaymentamt) as mtdpaymentamt -- 当月还款金额
    ,nvl(n.mtdpaymentcnt, o.mtdpaymentcnt) as mtdpaymentcnt -- 当月还款笔数
    ,nvl(n.ytdpaymentamt, o.ytdpaymentamt) as ytdpaymentamt -- 当年还款金额
    ,nvl(n.ytdpaymentcnt, o.ytdpaymentcnt) as ytdpaymentcnt -- 当年还款笔数
    ,nvl(n.ltdpaymentamt, o.ltdpaymentamt) as ltdpaymentamt -- 历史还款金额
    ,nvl(n.ltdpaymentcnt, o.ltdpaymentcnt) as ltdpaymentcnt -- 历史还款笔数
    ,nvl(n.lastpostdate, o.lastpostdate) as lastpostdate -- 上个批量处理日期
    ,nvl(n.lastsyncdate, o.lastsyncdate) as lastsyncdate -- 上一次入账的批量日期
    ,nvl(n.bankgroupid, o.bankgroupid) as bankgroupid -- 参贷方案编号
    ,nvl(n.bankproportion, o.bankproportion) as bankproportion -- 银行出资比例
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.acctno is null
            and n.accttype is null
            and n.bankgroupid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acctno is null
            and n.accttype is null
            and n.bankgroupid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acctno is null
            and n.accttype is null
            and n.bankgroupid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wld_tm_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wld_tm_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acctno = n.acctno
            and o.accttype = n.accttype
            and o.bankgroupid = n.bankgroupid
where (
        o.acctno is null
        and o.accttype is null
        and o.bankgroupid is null
    )
    or (
        n.acctno is null
        and n.accttype is null
        and n.bankgroupid is null
    )
    or (
        o.org <> n.org
        or o.custid <> n.custid
        or o.custlimitid <> n.custlimitid
        or o.productcd <> n.productcd
        or o.defaultlogicalcardno <> n.defaultlogicalcardno
        or o.currcd <> n.currcd
        or o.creditlimit <> n.creditlimit
        or o.templimit <> n.templimit
        or o.templimitbegindate <> n.templimitbegindate
        or o.templimitenddate <> n.templimitenddate
        or o.currbal <> n.currbal
        or o.principalbal <> n.principalbal
        or o.beginbal <> n.beginbal
        or o.pmtduedaybal <> n.pmtduedaybal
        or o.name <> n.name
        or o.gender <> n.gender
        or o.mobileno <> n.mobileno
        or o.billingcycle <> n.billingcycle
        or o.agecd <> n.agecd
        or o.unmatchdb <> n.unmatchdb
        or o.unmatchcr <> n.unmatchcr
        or o.ddind <> n.ddind
        or o.ddbankname <> n.ddbankname
        or o.ddbankbranch <> n.ddbankbranch
        or o.ddbankacctno <> n.ddbankacctno
        or o.ddbankacctname <> n.ddbankacctname
        or o.lastddamt <> n.lastddamt
        or o.lastdddate <> n.lastdddate
        or o.lastpmtamt <> n.lastpmtamt
        or o.lastpmtdate <> n.lastpmtdate
        or o.laststmtdate <> n.laststmtdate
        or o.lastpmtduedate <> n.lastpmtduedate
        or o.lastagingdate <> n.lastagingdate
        or o.collectdate <> n.collectdate
        or o.collectoutdate <> n.collectoutdate
        or o.nextstmtdate <> n.nextstmtdate
        or o.pmtduedate <> n.pmtduedate
        or o.dddate <> n.dddate
        or o.gracedate <> n.gracedate
        or o.closeddate <> n.closeddate
        or o.firststmtdate <> n.firststmtdate
        or o.canceldate <> n.canceldate
        or o.chargeoffdate <> n.chargeoffdate
        or o.ctdretailamt <> n.ctdretailamt
        or o.ctdretailcnt <> n.ctdretailcnt
        or o.ctdpaymentamt <> n.ctdpaymentamt
        or o.ctdpaymentcnt <> n.ctdpaymentcnt
        or o.ctddbadjamt <> n.ctddbadjamt
        or o.ctddbadjcnt <> n.ctddbadjcnt
        or o.ctdcradjamt <> n.ctdcradjamt
        or o.ctdcradjcnt <> n.ctdcradjcnt
        or o.ctdfeeamt <> n.ctdfeeamt
        or o.ctdfeecnt <> n.ctdfeecnt
        or o.ctdintegererestamt <> n.ctdintegererestamt
        or o.ctdintegererestcnt <> n.ctdintegererestcnt
        or o.mtdretailamt <> n.mtdretailamt
        or o.mtdretailcnt <> n.mtdretailcnt
        or o.ytdretailamt <> n.ytdretailamt
        or o.ytdretailcnt <> n.ytdretailcnt
        or o.waivesvcfeeind <> n.waivesvcfeeind
        or o.userdate2 <> n.userdate2
        or o.jpaversion <> n.jpaversion
        or o.mtdpaymentamt <> n.mtdpaymentamt
        or o.mtdpaymentcnt <> n.mtdpaymentcnt
        or o.ytdpaymentamt <> n.ytdpaymentamt
        or o.ytdpaymentcnt <> n.ytdpaymentcnt
        or o.ltdpaymentamt <> n.ltdpaymentamt
        or o.ltdpaymentcnt <> n.ltdpaymentcnt
        or o.lastpostdate <> n.lastpostdate
        or o.lastsyncdate <> n.lastsyncdate
        or o.bankproportion <> n.bankproportion
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wld_tm_account_cl(
            org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,custid -- 客户编号
            ,custlimitid -- 客户额度ID
            ,productcd -- 产品代码
            ,defaultlogicalcardno -- 默认逻辑卡号
            ,currcd -- 币种
            ,creditlimit -- 授信额度
            ,templimit -- 临时额度
            ,templimitbegindate -- 临时额度开始日期
            ,templimitenddate -- 临时额度结束日期
            ,currbal -- 当前余额
            ,principalbal -- 本金余额
            ,beginbal -- 上一到期日余额
            ,pmtduedaybal -- 到期还款日余额
            ,name -- 姓名
            ,gender -- 性别
            ,mobileno -- 移动电话
            ,billingcycle -- 还款日
            ,agecd -- 拖欠月数
            ,unmatchdb -- 未入账借记金额
            ,unmatchcr -- 未入账贷记金额
            ,ddind -- 约定还款类型
            ,ddbankname -- 约定还款银行名称
            ,ddbankbranch -- 约定还款开户行号
            ,ddbankacctno -- 约定还款扣款账号
            ,ddbankacctname -- 约定还款扣款账户姓名
            ,lastddamt -- 上期约定还款金额
            ,lastdddate -- 上期约定还款日期
            ,lastpmtamt -- 上笔还款金额
            ,lastpmtdate -- 上个还款日期
            ,laststmtdate -- 上个到期还款日期
            ,lastpmtduedate -- 上个到期还款日期
            ,lastagingdate -- 上个逾期月数提升日期
            ,collectdate -- 入催日期
            ,collectoutdate -- 出催收队列日期
            ,nextstmtdate -- 下个到期还款日期
            ,pmtduedate -- 到期还款日期
            ,dddate -- 约定还款日期
            ,gracedate -- 宽限日期
            ,closeddate -- 最终销户日期
            ,firststmtdate -- 首个到期还款日期
            ,canceldate -- 销户日期
            ,chargeoffdate -- 转呆账日期
            ,ctdretailamt -- 当期消费金额
            ,ctdretailcnt -- 当期消费笔数
            ,ctdpaymentamt -- 当期还款金额
            ,ctdpaymentcnt -- 当期还款笔数
            ,ctddbadjamt -- 当期借记调整金额
            ,ctddbadjcnt -- 当期借记调整笔数
            ,ctdcradjamt -- 当期贷记调整金额
            ,ctdcradjcnt -- 当期贷记调整笔数
            ,ctdfeeamt -- 当期费用金额
            ,ctdfeecnt -- 当期费用笔数
            ,ctdintegererestamt -- 当期利息金额
            ,ctdintegererestcnt -- 当期利息笔数
            ,mtdretailamt -- 本月消费金额
            ,mtdretailcnt -- 本月消费笔数
            ,ytdretailamt -- 本年消费金额
            ,ytdretailcnt -- 本年消费笔数
            ,waivesvcfeeind -- 是否免除服务费
            ,userdate2 -- 上次调额日期
            ,jpaversion -- 乐观锁版本号
            ,mtdpaymentamt -- 当月还款金额
            ,mtdpaymentcnt -- 当月还款笔数
            ,ytdpaymentamt -- 当年还款金额
            ,ytdpaymentcnt -- 当年还款笔数
            ,ltdpaymentamt -- 历史还款金额
            ,ltdpaymentcnt -- 历史还款笔数
            ,lastpostdate -- 上个批量处理日期
            ,lastsyncdate -- 上一次入账的批量日期
            ,bankgroupid -- 参贷方案编号
            ,bankproportion -- 银行出资比例
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wld_tm_account_op(
            org -- 机构号
            ,acctno -- 账户编号
            ,accttype -- 账户类型
            ,custid -- 客户编号
            ,custlimitid -- 客户额度ID
            ,productcd -- 产品代码
            ,defaultlogicalcardno -- 默认逻辑卡号
            ,currcd -- 币种
            ,creditlimit -- 授信额度
            ,templimit -- 临时额度
            ,templimitbegindate -- 临时额度开始日期
            ,templimitenddate -- 临时额度结束日期
            ,currbal -- 当前余额
            ,principalbal -- 本金余额
            ,beginbal -- 上一到期日余额
            ,pmtduedaybal -- 到期还款日余额
            ,name -- 姓名
            ,gender -- 性别
            ,mobileno -- 移动电话
            ,billingcycle -- 还款日
            ,agecd -- 拖欠月数
            ,unmatchdb -- 未入账借记金额
            ,unmatchcr -- 未入账贷记金额
            ,ddind -- 约定还款类型
            ,ddbankname -- 约定还款银行名称
            ,ddbankbranch -- 约定还款开户行号
            ,ddbankacctno -- 约定还款扣款账号
            ,ddbankacctname -- 约定还款扣款账户姓名
            ,lastddamt -- 上期约定还款金额
            ,lastdddate -- 上期约定还款日期
            ,lastpmtamt -- 上笔还款金额
            ,lastpmtdate -- 上个还款日期
            ,laststmtdate -- 上个到期还款日期
            ,lastpmtduedate -- 上个到期还款日期
            ,lastagingdate -- 上个逾期月数提升日期
            ,collectdate -- 入催日期
            ,collectoutdate -- 出催收队列日期
            ,nextstmtdate -- 下个到期还款日期
            ,pmtduedate -- 到期还款日期
            ,dddate -- 约定还款日期
            ,gracedate -- 宽限日期
            ,closeddate -- 最终销户日期
            ,firststmtdate -- 首个到期还款日期
            ,canceldate -- 销户日期
            ,chargeoffdate -- 转呆账日期
            ,ctdretailamt -- 当期消费金额
            ,ctdretailcnt -- 当期消费笔数
            ,ctdpaymentamt -- 当期还款金额
            ,ctdpaymentcnt -- 当期还款笔数
            ,ctddbadjamt -- 当期借记调整金额
            ,ctddbadjcnt -- 当期借记调整笔数
            ,ctdcradjamt -- 当期贷记调整金额
            ,ctdcradjcnt -- 当期贷记调整笔数
            ,ctdfeeamt -- 当期费用金额
            ,ctdfeecnt -- 当期费用笔数
            ,ctdintegererestamt -- 当期利息金额
            ,ctdintegererestcnt -- 当期利息笔数
            ,mtdretailamt -- 本月消费金额
            ,mtdretailcnt -- 本月消费笔数
            ,ytdretailamt -- 本年消费金额
            ,ytdretailcnt -- 本年消费笔数
            ,waivesvcfeeind -- 是否免除服务费
            ,userdate2 -- 上次调额日期
            ,jpaversion -- 乐观锁版本号
            ,mtdpaymentamt -- 当月还款金额
            ,mtdpaymentcnt -- 当月还款笔数
            ,ytdpaymentamt -- 当年还款金额
            ,ytdpaymentcnt -- 当年还款笔数
            ,ltdpaymentamt -- 历史还款金额
            ,ltdpaymentcnt -- 历史还款笔数
            ,lastpostdate -- 上个批量处理日期
            ,lastsyncdate -- 上一次入账的批量日期
            ,bankgroupid -- 参贷方案编号
            ,bankproportion -- 银行出资比例
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.acctno -- 账户编号
    ,o.accttype -- 账户类型
    ,o.custid -- 客户编号
    ,o.custlimitid -- 客户额度ID
    ,o.productcd -- 产品代码
    ,o.defaultlogicalcardno -- 默认逻辑卡号
    ,o.currcd -- 币种
    ,o.creditlimit -- 授信额度
    ,o.templimit -- 临时额度
    ,o.templimitbegindate -- 临时额度开始日期
    ,o.templimitenddate -- 临时额度结束日期
    ,o.currbal -- 当前余额
    ,o.principalbal -- 本金余额
    ,o.beginbal -- 上一到期日余额
    ,o.pmtduedaybal -- 到期还款日余额
    ,o.name -- 姓名
    ,o.gender -- 性别
    ,o.mobileno -- 移动电话
    ,o.billingcycle -- 还款日
    ,o.agecd -- 拖欠月数
    ,o.unmatchdb -- 未入账借记金额
    ,o.unmatchcr -- 未入账贷记金额
    ,o.ddind -- 约定还款类型
    ,o.ddbankname -- 约定还款银行名称
    ,o.ddbankbranch -- 约定还款开户行号
    ,o.ddbankacctno -- 约定还款扣款账号
    ,o.ddbankacctname -- 约定还款扣款账户姓名
    ,o.lastddamt -- 上期约定还款金额
    ,o.lastdddate -- 上期约定还款日期
    ,o.lastpmtamt -- 上笔还款金额
    ,o.lastpmtdate -- 上个还款日期
    ,o.laststmtdate -- 上个到期还款日期
    ,o.lastpmtduedate -- 上个到期还款日期
    ,o.lastagingdate -- 上个逾期月数提升日期
    ,o.collectdate -- 入催日期
    ,o.collectoutdate -- 出催收队列日期
    ,o.nextstmtdate -- 下个到期还款日期
    ,o.pmtduedate -- 到期还款日期
    ,o.dddate -- 约定还款日期
    ,o.gracedate -- 宽限日期
    ,o.closeddate -- 最终销户日期
    ,o.firststmtdate -- 首个到期还款日期
    ,o.canceldate -- 销户日期
    ,o.chargeoffdate -- 转呆账日期
    ,o.ctdretailamt -- 当期消费金额
    ,o.ctdretailcnt -- 当期消费笔数
    ,o.ctdpaymentamt -- 当期还款金额
    ,o.ctdpaymentcnt -- 当期还款笔数
    ,o.ctddbadjamt -- 当期借记调整金额
    ,o.ctddbadjcnt -- 当期借记调整笔数
    ,o.ctdcradjamt -- 当期贷记调整金额
    ,o.ctdcradjcnt -- 当期贷记调整笔数
    ,o.ctdfeeamt -- 当期费用金额
    ,o.ctdfeecnt -- 当期费用笔数
    ,o.ctdintegererestamt -- 当期利息金额
    ,o.ctdintegererestcnt -- 当期利息笔数
    ,o.mtdretailamt -- 本月消费金额
    ,o.mtdretailcnt -- 本月消费笔数
    ,o.ytdretailamt -- 本年消费金额
    ,o.ytdretailcnt -- 本年消费笔数
    ,o.waivesvcfeeind -- 是否免除服务费
    ,o.userdate2 -- 上次调额日期
    ,o.jpaversion -- 乐观锁版本号
    ,o.mtdpaymentamt -- 当月还款金额
    ,o.mtdpaymentcnt -- 当月还款笔数
    ,o.ytdpaymentamt -- 当年还款金额
    ,o.ytdpaymentcnt -- 当年还款笔数
    ,o.ltdpaymentamt -- 历史还款金额
    ,o.ltdpaymentcnt -- 历史还款笔数
    ,o.lastpostdate -- 上个批量处理日期
    ,o.lastsyncdate -- 上一次入账的批量日期
    ,o.bankgroupid -- 参贷方案编号
    ,o.bankproportion -- 银行出资比例
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.remark -- 备注
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
from ${iol_schema}.icms_wld_tm_account_bk o
    left join ${iol_schema}.icms_wld_tm_account_op n
        on
            o.acctno = n.acctno
            and o.accttype = n.accttype
            and o.bankgroupid = n.bankgroupid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wld_tm_account_cl d
        on
            o.acctno = d.acctno
            and o.accttype = d.accttype
            and o.bankgroupid = d.bankgroupid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wld_tm_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wld_tm_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wld_tm_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wld_tm_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wld_tm_account exchange partition p_${batch_date} with table ${iol_schema}.icms_wld_tm_account_cl;
alter table ${iol_schema}.icms_wld_tm_account exchange partition p_20991231 with table ${iol_schema}.icms_wld_tm_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wld_tm_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wld_tm_account_op purge;
drop table ${iol_schema}.icms_wld_tm_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wld_tm_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wld_tm_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
