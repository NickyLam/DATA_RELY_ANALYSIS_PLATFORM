/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wld_tm_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wld_tm_account
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wld_tm_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_tm_account(
    org varchar2(12) -- 机构号
    ,acctno number(20) -- 账户编号
    ,accttype varchar2(1) -- 账户类型
    ,custid number(20) -- 客户编号
    ,custlimitid number(20) -- 客户额度ID
    ,productcd varchar2(12) -- 产品代码
    ,defaultlogicalcardno varchar2(19) -- 默认逻辑卡号
    ,currcd varchar2(3) -- 币种
    ,creditlimit number(13) -- 授信额度
    ,templimit number(13) -- 临时额度
    ,templimitbegindate date -- 临时额度开始日期
    ,templimitenddate date -- 临时额度结束日期
    ,currbal number(19,6) -- 当前余额
    ,principalbal number(15,2) -- 本金余额
    ,beginbal number(15,2) -- 上一到期日余额
    ,pmtduedaybal number(15,2) -- 到期还款日余额
    ,name varchar2(160) -- 姓名
    ,gender varchar2(1) -- 性别
    ,mobileno varchar2(20) -- 移动电话
    ,billingcycle varchar2(2) -- 还款日
    ,agecd varchar2(1) -- 拖欠月数
    ,unmatchdb number(15,2) -- 未入账借记金额
    ,unmatchcr number(15,2) -- 未入账贷记金额
    ,ddind varchar2(1) -- 约定还款类型
    ,ddbankname varchar2(160) -- 约定还款银行名称
    ,ddbankbranch varchar2(14) -- 约定还款开户行号
    ,ddbankacctno varchar2(40) -- 约定还款扣款账号
    ,ddbankacctname varchar2(160) -- 约定还款扣款账户姓名
    ,lastddamt number(15,2) -- 上期约定还款金额
    ,lastdddate date -- 上期约定还款日期
    ,lastpmtamt number(15,2) -- 上笔还款金额
    ,lastpmtdate date -- 上个还款日期
    ,laststmtdate date -- 上个到期还款日期
    ,lastpmtduedate date -- 上个到期还款日期
    ,lastagingdate date -- 上个逾期月数提升日期
    ,collectdate date -- 入催日期
    ,collectoutdate date -- 出催收队列日期
    ,nextstmtdate date -- 下个到期还款日期
    ,pmtduedate date -- 到期还款日期
    ,dddate date -- 约定还款日期
    ,gracedate date -- 宽限日期
    ,closeddate date -- 最终销户日期
    ,firststmtdate date -- 首个到期还款日期
    ,canceldate date -- 销户日期
    ,chargeoffdate date -- 转呆账日期
    ,ctdretailamt number(15,2) -- 当期消费金额
    ,ctdretailcnt number(22) -- 当期消费笔数
    ,ctdpaymentamt number(15,2) -- 当期还款金额
    ,ctdpaymentcnt number(22) -- 当期还款笔数
    ,ctddbadjamt number(15,2) -- 当期借记调整金额
    ,ctddbadjcnt number(22) -- 当期借记调整笔数
    ,ctdcradjamt number(15,2) -- 当期贷记调整金额
    ,ctdcradjcnt number(22) -- 当期贷记调整笔数
    ,ctdfeeamt number(15,2) -- 当期费用金额
    ,ctdfeecnt number(22) -- 当期费用笔数
    ,ctdintegererestamt number(15,2) -- 当期利息金额
    ,ctdintegererestcnt number(22) -- 当期利息笔数
    ,mtdretailamt number(15,2) -- 本月消费金额
    ,mtdretailcnt number(22) -- 本月消费笔数
    ,ytdretailamt number(15,2) -- 本年消费金额
    ,ytdretailcnt number(22) -- 本年消费笔数
    ,waivesvcfeeind varchar2(1) -- 是否免除服务费
    ,userdate2 date -- 上次调额日期
    ,jpaversion number(22) -- 乐观锁版本号
    ,mtdpaymentamt number(15,2) -- 当月还款金额
    ,mtdpaymentcnt number(22) -- 当月还款笔数
    ,ytdpaymentamt number(15,2) -- 当年还款金额
    ,ytdpaymentcnt number(22) -- 当年还款笔数
    ,ltdpaymentamt number(15,2) -- 历史还款金额
    ,ltdpaymentcnt number(22) -- 历史还款笔数
    ,lastpostdate date -- 上个批量处理日期
    ,lastsyncdate date -- 上一次入账的批量日期
    ,bankgroupid varchar2(5) -- 参贷方案编号
    ,bankproportion number(5,2) -- 银行出资比例
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,remark varchar2(3000) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_wld_tm_account to ${iml_schema};
grant select on ${iol_schema}.icms_wld_tm_account to ${icl_schema};
grant select on ${iol_schema}.icms_wld_tm_account to ${idl_schema};
grant select on ${iol_schema}.icms_wld_tm_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wld_tm_account is '微粒贷账户信息表-核心批量';
comment on column ${iol_schema}.icms_wld_tm_account.org is '机构号';
comment on column ${iol_schema}.icms_wld_tm_account.acctno is '账户编号';
comment on column ${iol_schema}.icms_wld_tm_account.accttype is '账户类型';
comment on column ${iol_schema}.icms_wld_tm_account.custid is '客户编号';
comment on column ${iol_schema}.icms_wld_tm_account.custlimitid is '客户额度ID';
comment on column ${iol_schema}.icms_wld_tm_account.productcd is '产品代码';
comment on column ${iol_schema}.icms_wld_tm_account.defaultlogicalcardno is '默认逻辑卡号';
comment on column ${iol_schema}.icms_wld_tm_account.currcd is '币种';
comment on column ${iol_schema}.icms_wld_tm_account.creditlimit is '授信额度';
comment on column ${iol_schema}.icms_wld_tm_account.templimit is '临时额度';
comment on column ${iol_schema}.icms_wld_tm_account.templimitbegindate is '临时额度开始日期';
comment on column ${iol_schema}.icms_wld_tm_account.templimitenddate is '临时额度结束日期';
comment on column ${iol_schema}.icms_wld_tm_account.currbal is '当前余额';
comment on column ${iol_schema}.icms_wld_tm_account.principalbal is '本金余额';
comment on column ${iol_schema}.icms_wld_tm_account.beginbal is '上一到期日余额';
comment on column ${iol_schema}.icms_wld_tm_account.pmtduedaybal is '到期还款日余额';
comment on column ${iol_schema}.icms_wld_tm_account.name is '姓名';
comment on column ${iol_schema}.icms_wld_tm_account.gender is '性别';
comment on column ${iol_schema}.icms_wld_tm_account.mobileno is '移动电话';
comment on column ${iol_schema}.icms_wld_tm_account.billingcycle is '还款日';
comment on column ${iol_schema}.icms_wld_tm_account.agecd is '拖欠月数';
comment on column ${iol_schema}.icms_wld_tm_account.unmatchdb is '未入账借记金额';
comment on column ${iol_schema}.icms_wld_tm_account.unmatchcr is '未入账贷记金额';
comment on column ${iol_schema}.icms_wld_tm_account.ddind is '约定还款类型';
comment on column ${iol_schema}.icms_wld_tm_account.ddbankname is '约定还款银行名称';
comment on column ${iol_schema}.icms_wld_tm_account.ddbankbranch is '约定还款开户行号';
comment on column ${iol_schema}.icms_wld_tm_account.ddbankacctno is '约定还款扣款账号';
comment on column ${iol_schema}.icms_wld_tm_account.ddbankacctname is '约定还款扣款账户姓名';
comment on column ${iol_schema}.icms_wld_tm_account.lastddamt is '上期约定还款金额';
comment on column ${iol_schema}.icms_wld_tm_account.lastdddate is '上期约定还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.lastpmtamt is '上笔还款金额';
comment on column ${iol_schema}.icms_wld_tm_account.lastpmtdate is '上个还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.laststmtdate is '上个到期还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.lastpmtduedate is '上个到期还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.lastagingdate is '上个逾期月数提升日期';
comment on column ${iol_schema}.icms_wld_tm_account.collectdate is '入催日期';
comment on column ${iol_schema}.icms_wld_tm_account.collectoutdate is '出催收队列日期';
comment on column ${iol_schema}.icms_wld_tm_account.nextstmtdate is '下个到期还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.pmtduedate is '到期还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.dddate is '约定还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.gracedate is '宽限日期';
comment on column ${iol_schema}.icms_wld_tm_account.closeddate is '最终销户日期';
comment on column ${iol_schema}.icms_wld_tm_account.firststmtdate is '首个到期还款日期';
comment on column ${iol_schema}.icms_wld_tm_account.canceldate is '销户日期';
comment on column ${iol_schema}.icms_wld_tm_account.chargeoffdate is '转呆账日期';
comment on column ${iol_schema}.icms_wld_tm_account.ctdretailamt is '当期消费金额';
comment on column ${iol_schema}.icms_wld_tm_account.ctdretailcnt is '当期消费笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ctdpaymentamt is '当期还款金额';
comment on column ${iol_schema}.icms_wld_tm_account.ctdpaymentcnt is '当期还款笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ctddbadjamt is '当期借记调整金额';
comment on column ${iol_schema}.icms_wld_tm_account.ctddbadjcnt is '当期借记调整笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ctdcradjamt is '当期贷记调整金额';
comment on column ${iol_schema}.icms_wld_tm_account.ctdcradjcnt is '当期贷记调整笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ctdfeeamt is '当期费用金额';
comment on column ${iol_schema}.icms_wld_tm_account.ctdfeecnt is '当期费用笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ctdintegererestamt is '当期利息金额';
comment on column ${iol_schema}.icms_wld_tm_account.ctdintegererestcnt is '当期利息笔数';
comment on column ${iol_schema}.icms_wld_tm_account.mtdretailamt is '本月消费金额';
comment on column ${iol_schema}.icms_wld_tm_account.mtdretailcnt is '本月消费笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ytdretailamt is '本年消费金额';
comment on column ${iol_schema}.icms_wld_tm_account.ytdretailcnt is '本年消费笔数';
comment on column ${iol_schema}.icms_wld_tm_account.waivesvcfeeind is '是否免除服务费';
comment on column ${iol_schema}.icms_wld_tm_account.userdate2 is '上次调额日期';
comment on column ${iol_schema}.icms_wld_tm_account.jpaversion is '乐观锁版本号';
comment on column ${iol_schema}.icms_wld_tm_account.mtdpaymentamt is '当月还款金额';
comment on column ${iol_schema}.icms_wld_tm_account.mtdpaymentcnt is '当月还款笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ytdpaymentamt is '当年还款金额';
comment on column ${iol_schema}.icms_wld_tm_account.ytdpaymentcnt is '当年还款笔数';
comment on column ${iol_schema}.icms_wld_tm_account.ltdpaymentamt is '历史还款金额';
comment on column ${iol_schema}.icms_wld_tm_account.ltdpaymentcnt is '历史还款笔数';
comment on column ${iol_schema}.icms_wld_tm_account.lastpostdate is '上个批量处理日期';
comment on column ${iol_schema}.icms_wld_tm_account.lastsyncdate is '上一次入账的批量日期';
comment on column ${iol_schema}.icms_wld_tm_account.bankgroupid is '参贷方案编号';
comment on column ${iol_schema}.icms_wld_tm_account.bankproportion is '银行出资比例';
comment on column ${iol_schema}.icms_wld_tm_account.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wld_tm_account.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wld_tm_account.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wld_tm_account.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wld_tm_account.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wld_tm_account.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wld_tm_account.remark is '备注';
comment on column ${iol_schema}.icms_wld_tm_account.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wld_tm_account.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wld_tm_account.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wld_tm_account.etl_timestamp is 'ETL处理时间戳';
