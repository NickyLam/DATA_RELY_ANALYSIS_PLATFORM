/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1stacctptcidinfo
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
create table ${iol_schema}.mpcs_a1stacctptcidinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1stacctptcidinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1stacctptcidinfo_op purge;
drop table ${iol_schema}.mpcs_a1stacctptcidinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1stacctptcidinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1stacctptcidinfo where 0=1;

create table ${iol_schema}.mpcs_a1stacctptcidinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1stacctptcidinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1stacctptcidinfo_cl(
            transdt -- 登记日期
            ,trntm -- 登记时间
            ,managementtype -- 签约状态 0-解约 1-签约 2-待生效
            ,ptcidno -- 挂接协议号
            ,msgsndcd -- 动态关联码
            ,msgvrfy -- 动态验证码
            ,sgnacctptyid -- 签约人银行账户所属机构
            ,sgnaccttp -- 签约人银行账户类型 AT00：个人银行借记账户 AT01：个人银行贷记账户 AT02：个人银行准贷记账户 AT03：单位银行结算账户 AT04：基本存款账户 AT05：一般存款账户 AT06：临时存款账户 AT07：DC/EP特殊存款账户
            ,sgnacctidkey -- 签约人银行账户账号
            ,sgnacctnmkey -- 签约人银行账户户名
            ,idtype -- 签约人证件类型 IT01：居民身份证 IT02：军官证 IT03：护照 IT04：户口薄 IT05：士兵证 IT06：港澳往来内地通行证 IT07：台湾同胞来往内地通行证 IT08：临时身份证 IT09：外国人居留证 IT10：警官证 IT11：营业执照 IT12：组织机构代码 IT13：税务登记证 IT14：统一社会信用代码证 IT15：事业单位法人证书 IT16：社会团体法人登记证书 IT17：民办非企业单位登记证书 IT18: 开户许可通知书 IT99：其他
            ,idnumberkey -- 签约人证件号码
            ,telephonekey -- 银行预留手机号码
            ,waltetptyid -- 钱包开立所属机构编码
            ,waltetidkey -- 钱包ID
            ,waltettype -- 钱包类型 WT01：个人钱包 WT02：子个人钱包 WT03：硬件钱包 WT09：对公钱包 WT10：子对公钱包
            ,walletlevel -- 钱包等级 WL01：一类钱包 WL02：二类钱包 WL03：三类钱包 WL04：四类钱包
            ,fisttlr -- 签约柜员
            ,recvtlr -- 解约柜员
            ,fisttime -- 签约时间
            ,recvtime -- 解约时间
            ,mainseq -- 中台流水号
            ,reflag -- 已换卡标识（1 已换卡，0 未换卡）
            ,newsgnacctid -- 新卡账号
            ,chgtime -- 换卡时间
            ,unsignseqno -- 解约流水
            ,sgnacctptyname -- 签约人银行账户所属机构名称
            ,waltetptyname -- 钱包开立所属机构编码名称
            ,sndbrn -- 发起机构
            ,idenduedt -- 证件失效日期
            ,corprtnnm -- 单位名称
            ,pckno -- 报文类型
            ,lglrepnm -- 法定代表人或单位负责人姓名
            ,lglrepidtp -- 法定代表人或单位负责人证件类型
            ,lglrepidno -- 法定代表人或单位负责人证件号码
            ,sngltxamtlmt -- 单笔兑出业务金额上限
            ,dlttlcnt -- 日累计兑出业务笔数上限
            ,dlttlamtlmt -- 日累计兑出业务金额上限
            ,anlttlcnt -- 年累计兑出业务笔数上限
            ,anlttlamtlmt -- 年累计兑出业务金额上限
            ,ptcfctvdt -- 协议生效日期
            ,ptcifctvdt -- 协议失效日期
            ,sgnchnl -- 签约渠道
            ,magebrn -- 管理机构
            ,custtype -- 客户类型 1-个人 2-对公 3-内部户
            ,contextno -- 掌银App业务参数中的ContextNo
            ,custno -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1stacctptcidinfo_op(
            transdt -- 登记日期
            ,trntm -- 登记时间
            ,managementtype -- 签约状态 0-解约 1-签约 2-待生效
            ,ptcidno -- 挂接协议号
            ,msgsndcd -- 动态关联码
            ,msgvrfy -- 动态验证码
            ,sgnacctptyid -- 签约人银行账户所属机构
            ,sgnaccttp -- 签约人银行账户类型 AT00：个人银行借记账户 AT01：个人银行贷记账户 AT02：个人银行准贷记账户 AT03：单位银行结算账户 AT04：基本存款账户 AT05：一般存款账户 AT06：临时存款账户 AT07：DC/EP特殊存款账户
            ,sgnacctidkey -- 签约人银行账户账号
            ,sgnacctnmkey -- 签约人银行账户户名
            ,idtype -- 签约人证件类型 IT01：居民身份证 IT02：军官证 IT03：护照 IT04：户口薄 IT05：士兵证 IT06：港澳往来内地通行证 IT07：台湾同胞来往内地通行证 IT08：临时身份证 IT09：外国人居留证 IT10：警官证 IT11：营业执照 IT12：组织机构代码 IT13：税务登记证 IT14：统一社会信用代码证 IT15：事业单位法人证书 IT16：社会团体法人登记证书 IT17：民办非企业单位登记证书 IT18: 开户许可通知书 IT99：其他
            ,idnumberkey -- 签约人证件号码
            ,telephonekey -- 银行预留手机号码
            ,waltetptyid -- 钱包开立所属机构编码
            ,waltetidkey -- 钱包ID
            ,waltettype -- 钱包类型 WT01：个人钱包 WT02：子个人钱包 WT03：硬件钱包 WT09：对公钱包 WT10：子对公钱包
            ,walletlevel -- 钱包等级 WL01：一类钱包 WL02：二类钱包 WL03：三类钱包 WL04：四类钱包
            ,fisttlr -- 签约柜员
            ,recvtlr -- 解约柜员
            ,fisttime -- 签约时间
            ,recvtime -- 解约时间
            ,mainseq -- 中台流水号
            ,reflag -- 已换卡标识（1 已换卡，0 未换卡）
            ,newsgnacctid -- 新卡账号
            ,chgtime -- 换卡时间
            ,unsignseqno -- 解约流水
            ,sgnacctptyname -- 签约人银行账户所属机构名称
            ,waltetptyname -- 钱包开立所属机构编码名称
            ,sndbrn -- 发起机构
            ,idenduedt -- 证件失效日期
            ,corprtnnm -- 单位名称
            ,pckno -- 报文类型
            ,lglrepnm -- 法定代表人或单位负责人姓名
            ,lglrepidtp -- 法定代表人或单位负责人证件类型
            ,lglrepidno -- 法定代表人或单位负责人证件号码
            ,sngltxamtlmt -- 单笔兑出业务金额上限
            ,dlttlcnt -- 日累计兑出业务笔数上限
            ,dlttlamtlmt -- 日累计兑出业务金额上限
            ,anlttlcnt -- 年累计兑出业务笔数上限
            ,anlttlamtlmt -- 年累计兑出业务金额上限
            ,ptcfctvdt -- 协议生效日期
            ,ptcifctvdt -- 协议失效日期
            ,sgnchnl -- 签约渠道
            ,magebrn -- 管理机构
            ,custtype -- 客户类型 1-个人 2-对公 3-内部户
            ,contextno -- 掌银App业务参数中的ContextNo
            ,custno -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 登记日期
    ,nvl(n.trntm, o.trntm) as trntm -- 登记时间
    ,nvl(n.managementtype, o.managementtype) as managementtype -- 签约状态 0-解约 1-签约 2-待生效
    ,nvl(n.ptcidno, o.ptcidno) as ptcidno -- 挂接协议号
    ,nvl(n.msgsndcd, o.msgsndcd) as msgsndcd -- 动态关联码
    ,nvl(n.msgvrfy, o.msgvrfy) as msgvrfy -- 动态验证码
    ,nvl(n.sgnacctptyid, o.sgnacctptyid) as sgnacctptyid -- 签约人银行账户所属机构
    ,nvl(n.sgnaccttp, o.sgnaccttp) as sgnaccttp -- 签约人银行账户类型 AT00：个人银行借记账户 AT01：个人银行贷记账户 AT02：个人银行准贷记账户 AT03：单位银行结算账户 AT04：基本存款账户 AT05：一般存款账户 AT06：临时存款账户 AT07：DC/EP特殊存款账户
    ,nvl(n.sgnacctidkey, o.sgnacctidkey) as sgnacctidkey -- 签约人银行账户账号
    ,nvl(n.sgnacctnmkey, o.sgnacctnmkey) as sgnacctnmkey -- 签约人银行账户户名
    ,nvl(n.idtype, o.idtype) as idtype -- 签约人证件类型 IT01：居民身份证 IT02：军官证 IT03：护照 IT04：户口薄 IT05：士兵证 IT06：港澳往来内地通行证 IT07：台湾同胞来往内地通行证 IT08：临时身份证 IT09：外国人居留证 IT10：警官证 IT11：营业执照 IT12：组织机构代码 IT13：税务登记证 IT14：统一社会信用代码证 IT15：事业单位法人证书 IT16：社会团体法人登记证书 IT17：民办非企业单位登记证书 IT18: 开户许可通知书 IT99：其他
    ,nvl(n.idnumberkey, o.idnumberkey) as idnumberkey -- 签约人证件号码
    ,nvl(n.telephonekey, o.telephonekey) as telephonekey -- 银行预留手机号码
    ,nvl(n.waltetptyid, o.waltetptyid) as waltetptyid -- 钱包开立所属机构编码
    ,nvl(n.waltetidkey, o.waltetidkey) as waltetidkey -- 钱包ID
    ,nvl(n.waltettype, o.waltettype) as waltettype -- 钱包类型 WT01：个人钱包 WT02：子个人钱包 WT03：硬件钱包 WT09：对公钱包 WT10：子对公钱包
    ,nvl(n.walletlevel, o.walletlevel) as walletlevel -- 钱包等级 WL01：一类钱包 WL02：二类钱包 WL03：三类钱包 WL04：四类钱包
    ,nvl(n.fisttlr, o.fisttlr) as fisttlr -- 签约柜员
    ,nvl(n.recvtlr, o.recvtlr) as recvtlr -- 解约柜员
    ,nvl(n.fisttime, o.fisttime) as fisttime -- 签约时间
    ,nvl(n.recvtime, o.recvtime) as recvtime -- 解约时间
    ,nvl(n.mainseq, o.mainseq) as mainseq -- 中台流水号
    ,nvl(n.reflag, o.reflag) as reflag -- 已换卡标识（1 已换卡，0 未换卡）
    ,nvl(n.newsgnacctid, o.newsgnacctid) as newsgnacctid -- 新卡账号
    ,nvl(n.chgtime, o.chgtime) as chgtime -- 换卡时间
    ,nvl(n.unsignseqno, o.unsignseqno) as unsignseqno -- 解约流水
    ,nvl(n.sgnacctptyname, o.sgnacctptyname) as sgnacctptyname -- 签约人银行账户所属机构名称
    ,nvl(n.waltetptyname, o.waltetptyname) as waltetptyname -- 钱包开立所属机构编码名称
    ,nvl(n.sndbrn, o.sndbrn) as sndbrn -- 发起机构
    ,nvl(n.idenduedt, o.idenduedt) as idenduedt -- 证件失效日期
    ,nvl(n.corprtnnm, o.corprtnnm) as corprtnnm -- 单位名称
    ,nvl(n.pckno, o.pckno) as pckno -- 报文类型
    ,nvl(n.lglrepnm, o.lglrepnm) as lglrepnm -- 法定代表人或单位负责人姓名
    ,nvl(n.lglrepidtp, o.lglrepidtp) as lglrepidtp -- 法定代表人或单位负责人证件类型
    ,nvl(n.lglrepidno, o.lglrepidno) as lglrepidno -- 法定代表人或单位负责人证件号码
    ,nvl(n.sngltxamtlmt, o.sngltxamtlmt) as sngltxamtlmt -- 单笔兑出业务金额上限
    ,nvl(n.dlttlcnt, o.dlttlcnt) as dlttlcnt -- 日累计兑出业务笔数上限
    ,nvl(n.dlttlamtlmt, o.dlttlamtlmt) as dlttlamtlmt -- 日累计兑出业务金额上限
    ,nvl(n.anlttlcnt, o.anlttlcnt) as anlttlcnt -- 年累计兑出业务笔数上限
    ,nvl(n.anlttlamtlmt, o.anlttlamtlmt) as anlttlamtlmt -- 年累计兑出业务金额上限
    ,nvl(n.ptcfctvdt, o.ptcfctvdt) as ptcfctvdt -- 协议生效日期
    ,nvl(n.ptcifctvdt, o.ptcifctvdt) as ptcifctvdt -- 协议失效日期
    ,nvl(n.sgnchnl, o.sgnchnl) as sgnchnl -- 签约渠道
    ,nvl(n.magebrn, o.magebrn) as magebrn -- 管理机构
    ,nvl(n.custtype, o.custtype) as custtype -- 客户类型 1-个人 2-对公 3-内部户
    ,nvl(n.contextno, o.contextno) as contextno -- 掌银App业务参数中的ContextNo
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,case when
            n.mainseq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mainseq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mainseq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1stacctptcidinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1stacctptcidinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mainseq = n.mainseq
where (
        o.mainseq is null
    )
    or (
        n.mainseq is null
    )
    or (
        o.transdt <> n.transdt
        or o.trntm <> n.trntm
        or o.managementtype <> n.managementtype
        or o.ptcidno <> n.ptcidno
        or o.msgsndcd <> n.msgsndcd
        or o.msgvrfy <> n.msgvrfy
        or o.sgnacctptyid <> n.sgnacctptyid
        or o.sgnaccttp <> n.sgnaccttp
        or o.sgnacctidkey <> n.sgnacctidkey
        or o.sgnacctnmkey <> n.sgnacctnmkey
        or o.idtype <> n.idtype
        or o.idnumberkey <> n.idnumberkey
        or o.telephonekey <> n.telephonekey
        or o.waltetptyid <> n.waltetptyid
        or o.waltetidkey <> n.waltetidkey
        or o.waltettype <> n.waltettype
        or o.walletlevel <> n.walletlevel
        or o.fisttlr <> n.fisttlr
        or o.recvtlr <> n.recvtlr
        or o.fisttime <> n.fisttime
        or o.recvtime <> n.recvtime
        or o.reflag <> n.reflag
        or o.newsgnacctid <> n.newsgnacctid
        or o.chgtime <> n.chgtime
        or o.unsignseqno <> n.unsignseqno
        or o.sgnacctptyname <> n.sgnacctptyname
        or o.waltetptyname <> n.waltetptyname
        or o.sndbrn <> n.sndbrn
        or o.idenduedt <> n.idenduedt
        or o.corprtnnm <> n.corprtnnm
        or o.pckno <> n.pckno
        or o.lglrepnm <> n.lglrepnm
        or o.lglrepidtp <> n.lglrepidtp
        or o.lglrepidno <> n.lglrepidno
        or o.sngltxamtlmt <> n.sngltxamtlmt
        or o.dlttlcnt <> n.dlttlcnt
        or o.dlttlamtlmt <> n.dlttlamtlmt
        or o.anlttlcnt <> n.anlttlcnt
        or o.anlttlamtlmt <> n.anlttlamtlmt
        or o.ptcfctvdt <> n.ptcfctvdt
        or o.ptcifctvdt <> n.ptcifctvdt
        or o.sgnchnl <> n.sgnchnl
        or o.magebrn <> n.magebrn
        or o.custtype <> n.custtype
        or o.contextno <> n.contextno
        or o.custno <> n.custno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1stacctptcidinfo_cl(
            transdt -- 登记日期
            ,trntm -- 登记时间
            ,managementtype -- 签约状态 0-解约 1-签约 2-待生效
            ,ptcidno -- 挂接协议号
            ,msgsndcd -- 动态关联码
            ,msgvrfy -- 动态验证码
            ,sgnacctptyid -- 签约人银行账户所属机构
            ,sgnaccttp -- 签约人银行账户类型 AT00：个人银行借记账户 AT01：个人银行贷记账户 AT02：个人银行准贷记账户 AT03：单位银行结算账户 AT04：基本存款账户 AT05：一般存款账户 AT06：临时存款账户 AT07：DC/EP特殊存款账户
            ,sgnacctidkey -- 签约人银行账户账号
            ,sgnacctnmkey -- 签约人银行账户户名
            ,idtype -- 签约人证件类型 IT01：居民身份证 IT02：军官证 IT03：护照 IT04：户口薄 IT05：士兵证 IT06：港澳往来内地通行证 IT07：台湾同胞来往内地通行证 IT08：临时身份证 IT09：外国人居留证 IT10：警官证 IT11：营业执照 IT12：组织机构代码 IT13：税务登记证 IT14：统一社会信用代码证 IT15：事业单位法人证书 IT16：社会团体法人登记证书 IT17：民办非企业单位登记证书 IT18: 开户许可通知书 IT99：其他
            ,idnumberkey -- 签约人证件号码
            ,telephonekey -- 银行预留手机号码
            ,waltetptyid -- 钱包开立所属机构编码
            ,waltetidkey -- 钱包ID
            ,waltettype -- 钱包类型 WT01：个人钱包 WT02：子个人钱包 WT03：硬件钱包 WT09：对公钱包 WT10：子对公钱包
            ,walletlevel -- 钱包等级 WL01：一类钱包 WL02：二类钱包 WL03：三类钱包 WL04：四类钱包
            ,fisttlr -- 签约柜员
            ,recvtlr -- 解约柜员
            ,fisttime -- 签约时间
            ,recvtime -- 解约时间
            ,mainseq -- 中台流水号
            ,reflag -- 已换卡标识（1 已换卡，0 未换卡）
            ,newsgnacctid -- 新卡账号
            ,chgtime -- 换卡时间
            ,unsignseqno -- 解约流水
            ,sgnacctptyname -- 签约人银行账户所属机构名称
            ,waltetptyname -- 钱包开立所属机构编码名称
            ,sndbrn -- 发起机构
            ,idenduedt -- 证件失效日期
            ,corprtnnm -- 单位名称
            ,pckno -- 报文类型
            ,lglrepnm -- 法定代表人或单位负责人姓名
            ,lglrepidtp -- 法定代表人或单位负责人证件类型
            ,lglrepidno -- 法定代表人或单位负责人证件号码
            ,sngltxamtlmt -- 单笔兑出业务金额上限
            ,dlttlcnt -- 日累计兑出业务笔数上限
            ,dlttlamtlmt -- 日累计兑出业务金额上限
            ,anlttlcnt -- 年累计兑出业务笔数上限
            ,anlttlamtlmt -- 年累计兑出业务金额上限
            ,ptcfctvdt -- 协议生效日期
            ,ptcifctvdt -- 协议失效日期
            ,sgnchnl -- 签约渠道
            ,magebrn -- 管理机构
            ,custtype -- 客户类型 1-个人 2-对公 3-内部户
            ,contextno -- 掌银App业务参数中的ContextNo
            ,custno -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1stacctptcidinfo_op(
            transdt -- 登记日期
            ,trntm -- 登记时间
            ,managementtype -- 签约状态 0-解约 1-签约 2-待生效
            ,ptcidno -- 挂接协议号
            ,msgsndcd -- 动态关联码
            ,msgvrfy -- 动态验证码
            ,sgnacctptyid -- 签约人银行账户所属机构
            ,sgnaccttp -- 签约人银行账户类型 AT00：个人银行借记账户 AT01：个人银行贷记账户 AT02：个人银行准贷记账户 AT03：单位银行结算账户 AT04：基本存款账户 AT05：一般存款账户 AT06：临时存款账户 AT07：DC/EP特殊存款账户
            ,sgnacctidkey -- 签约人银行账户账号
            ,sgnacctnmkey -- 签约人银行账户户名
            ,idtype -- 签约人证件类型 IT01：居民身份证 IT02：军官证 IT03：护照 IT04：户口薄 IT05：士兵证 IT06：港澳往来内地通行证 IT07：台湾同胞来往内地通行证 IT08：临时身份证 IT09：外国人居留证 IT10：警官证 IT11：营业执照 IT12：组织机构代码 IT13：税务登记证 IT14：统一社会信用代码证 IT15：事业单位法人证书 IT16：社会团体法人登记证书 IT17：民办非企业单位登记证书 IT18: 开户许可通知书 IT99：其他
            ,idnumberkey -- 签约人证件号码
            ,telephonekey -- 银行预留手机号码
            ,waltetptyid -- 钱包开立所属机构编码
            ,waltetidkey -- 钱包ID
            ,waltettype -- 钱包类型 WT01：个人钱包 WT02：子个人钱包 WT03：硬件钱包 WT09：对公钱包 WT10：子对公钱包
            ,walletlevel -- 钱包等级 WL01：一类钱包 WL02：二类钱包 WL03：三类钱包 WL04：四类钱包
            ,fisttlr -- 签约柜员
            ,recvtlr -- 解约柜员
            ,fisttime -- 签约时间
            ,recvtime -- 解约时间
            ,mainseq -- 中台流水号
            ,reflag -- 已换卡标识（1 已换卡，0 未换卡）
            ,newsgnacctid -- 新卡账号
            ,chgtime -- 换卡时间
            ,unsignseqno -- 解约流水
            ,sgnacctptyname -- 签约人银行账户所属机构名称
            ,waltetptyname -- 钱包开立所属机构编码名称
            ,sndbrn -- 发起机构
            ,idenduedt -- 证件失效日期
            ,corprtnnm -- 单位名称
            ,pckno -- 报文类型
            ,lglrepnm -- 法定代表人或单位负责人姓名
            ,lglrepidtp -- 法定代表人或单位负责人证件类型
            ,lglrepidno -- 法定代表人或单位负责人证件号码
            ,sngltxamtlmt -- 单笔兑出业务金额上限
            ,dlttlcnt -- 日累计兑出业务笔数上限
            ,dlttlamtlmt -- 日累计兑出业务金额上限
            ,anlttlcnt -- 年累计兑出业务笔数上限
            ,anlttlamtlmt -- 年累计兑出业务金额上限
            ,ptcfctvdt -- 协议生效日期
            ,ptcifctvdt -- 协议失效日期
            ,sgnchnl -- 签约渠道
            ,magebrn -- 管理机构
            ,custtype -- 客户类型 1-个人 2-对公 3-内部户
            ,contextno -- 掌银App业务参数中的ContextNo
            ,custno -- 客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 登记日期
    ,o.trntm -- 登记时间
    ,o.managementtype -- 签约状态 0-解约 1-签约 2-待生效
    ,o.ptcidno -- 挂接协议号
    ,o.msgsndcd -- 动态关联码
    ,o.msgvrfy -- 动态验证码
    ,o.sgnacctptyid -- 签约人银行账户所属机构
    ,o.sgnaccttp -- 签约人银行账户类型 AT00：个人银行借记账户 AT01：个人银行贷记账户 AT02：个人银行准贷记账户 AT03：单位银行结算账户 AT04：基本存款账户 AT05：一般存款账户 AT06：临时存款账户 AT07：DC/EP特殊存款账户
    ,o.sgnacctidkey -- 签约人银行账户账号
    ,o.sgnacctnmkey -- 签约人银行账户户名
    ,o.idtype -- 签约人证件类型 IT01：居民身份证 IT02：军官证 IT03：护照 IT04：户口薄 IT05：士兵证 IT06：港澳往来内地通行证 IT07：台湾同胞来往内地通行证 IT08：临时身份证 IT09：外国人居留证 IT10：警官证 IT11：营业执照 IT12：组织机构代码 IT13：税务登记证 IT14：统一社会信用代码证 IT15：事业单位法人证书 IT16：社会团体法人登记证书 IT17：民办非企业单位登记证书 IT18: 开户许可通知书 IT99：其他
    ,o.idnumberkey -- 签约人证件号码
    ,o.telephonekey -- 银行预留手机号码
    ,o.waltetptyid -- 钱包开立所属机构编码
    ,o.waltetidkey -- 钱包ID
    ,o.waltettype -- 钱包类型 WT01：个人钱包 WT02：子个人钱包 WT03：硬件钱包 WT09：对公钱包 WT10：子对公钱包
    ,o.walletlevel -- 钱包等级 WL01：一类钱包 WL02：二类钱包 WL03：三类钱包 WL04：四类钱包
    ,o.fisttlr -- 签约柜员
    ,o.recvtlr -- 解约柜员
    ,o.fisttime -- 签约时间
    ,o.recvtime -- 解约时间
    ,o.mainseq -- 中台流水号
    ,o.reflag -- 已换卡标识（1 已换卡，0 未换卡）
    ,o.newsgnacctid -- 新卡账号
    ,o.chgtime -- 换卡时间
    ,o.unsignseqno -- 解约流水
    ,o.sgnacctptyname -- 签约人银行账户所属机构名称
    ,o.waltetptyname -- 钱包开立所属机构编码名称
    ,o.sndbrn -- 发起机构
    ,o.idenduedt -- 证件失效日期
    ,o.corprtnnm -- 单位名称
    ,o.pckno -- 报文类型
    ,o.lglrepnm -- 法定代表人或单位负责人姓名
    ,o.lglrepidtp -- 法定代表人或单位负责人证件类型
    ,o.lglrepidno -- 法定代表人或单位负责人证件号码
    ,o.sngltxamtlmt -- 单笔兑出业务金额上限
    ,o.dlttlcnt -- 日累计兑出业务笔数上限
    ,o.dlttlamtlmt -- 日累计兑出业务金额上限
    ,o.anlttlcnt -- 年累计兑出业务笔数上限
    ,o.anlttlamtlmt -- 年累计兑出业务金额上限
    ,o.ptcfctvdt -- 协议生效日期
    ,o.ptcifctvdt -- 协议失效日期
    ,o.sgnchnl -- 签约渠道
    ,o.magebrn -- 管理机构
    ,o.custtype -- 客户类型 1-个人 2-对公 3-内部户
    ,o.contextno -- 掌银App业务参数中的ContextNo
    ,o.custno -- 客户号
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
from ${iol_schema}.mpcs_a1stacctptcidinfo_bk o
    left join ${iol_schema}.mpcs_a1stacctptcidinfo_op n
        on
            o.mainseq = n.mainseq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1stacctptcidinfo_cl d
        on
            o.mainseq = d.mainseq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1stacctptcidinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1stacctptcidinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1stacctptcidinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1stacctptcidinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1stacctptcidinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1stacctptcidinfo_cl;
alter table ${iol_schema}.mpcs_a1stacctptcidinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a1stacctptcidinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1stacctptcidinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1stacctptcidinfo_op purge;
drop table ${iol_schema}.mpcs_a1stacctptcidinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1stacctptcidinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1stacctptcidinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
