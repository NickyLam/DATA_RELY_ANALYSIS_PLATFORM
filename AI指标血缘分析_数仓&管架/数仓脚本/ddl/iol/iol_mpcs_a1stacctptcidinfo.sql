/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1stacctptcidinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1stacctptcidinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1stacctptcidinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1stacctptcidinfo(
    transdt varchar2(8) -- 登记日期
    ,trntm varchar2(20) -- 登记时间
    ,managementtype varchar2(4) -- 签约状态 0-解约 1-签约 2-待生效
    ,ptcidno varchar2(68) -- 挂接协议号
    ,msgsndcd varchar2(128) -- 动态关联码
    ,msgvrfy varchar2(20) -- 动态验证码
    ,sgnacctptyid varchar2(14) -- 签约人银行账户所属机构
    ,sgnaccttp varchar2(4) -- 签约人银行账户类型 at00：个人银行借记账户 at01：个人银行贷记账户 at02：个人银行准贷记账户 at03：单位银行结算账户 at04：基本存款账户 at05：一般存款账户 at06：临时存款账户 at07：dc/ep特殊存款账户
    ,sgnacctidkey varchar2(1000) -- 签约人银行账户账号
    ,sgnacctnmkey varchar2(1000) -- 签约人银行账户户名
    ,idtype varchar2(4) -- 签约人证件类型 it01：居民身份证 it02：军官证 it03：护照 it04：户口薄 it05：士兵证 it06：港澳往来内地通行证 it07：台湾同胞来往内地通行证 it08：临时身份证 it09：外国人居留证 it10：警官证 it11：营业执照 it12：组织机构代码 it13：税务登记证 it14：统一社会信用代码证 it15：事业单位法人证书 it16：社会团体法人登记证书 it17：民办非企业单位登记证书 it18: 开户许可通知书 it99：其他
    ,idnumberkey varchar2(1000) -- 签约人证件号码
    ,telephonekey varchar2(1000) -- 银行预留手机号码
    ,waltetptyid varchar2(14) -- 钱包开立所属机构编码
    ,waltetidkey varchar2(1500) -- 钱包id
    ,waltettype varchar2(6) -- 钱包类型 wt01：个人钱包 wt02：子个人钱包 wt03：硬件钱包 wt09：对公钱包 wt10：子对公钱包
    ,walletlevel varchar2(6) -- 钱包等级 wl01：一类钱包 wl02：二类钱包 wl03：三类钱包 wl04：四类钱包
    ,fisttlr varchar2(15) -- 签约柜员
    ,recvtlr varchar2(15) -- 解约柜员
    ,fisttime varchar2(30) -- 签约时间
    ,recvtime varchar2(30) -- 解约时间
    ,mainseq varchar2(30) -- 中台流水号
    ,reflag varchar2(3) -- 已换卡标识（1 已换卡，0 未换卡）
    ,newsgnacctid varchar2(102) -- 新卡账号
    ,chgtime varchar2(30) -- 换卡时间
    ,unsignseqno varchar2(60) -- 解约流水
    ,sgnacctptyname varchar2(180) -- 签约人银行账户所属机构名称
    ,waltetptyname varchar2(180) -- 钱包开立所属机构编码名称
    ,sndbrn varchar2(21) -- 发起机构
    ,idenduedt varchar2(12) -- 证件失效日期
    ,corprtnnm varchar2(180) -- 单位名称
    ,pckno varchar2(30) -- 报文类型
    ,lglrepnm varchar2(1500) -- 法定代表人或单位负责人姓名
    ,lglrepidtp varchar2(6) -- 法定代表人或单位负责人证件类型
    ,lglrepidno varchar2(1500) -- 法定代表人或单位负责人证件号码
    ,sngltxamtlmt varchar2(29) -- 单笔兑出业务金额上限
    ,dlttlcnt varchar2(12) -- 日累计兑出业务笔数上限
    ,dlttlamtlmt varchar2(29) -- 日累计兑出业务金额上限
    ,anlttlcnt varchar2(12) -- 年累计兑出业务笔数上限
    ,anlttlamtlmt varchar2(29) -- 年累计兑出业务金额上限
    ,ptcfctvdt varchar2(12) -- 协议生效日期
    ,ptcifctvdt varchar2(12) -- 协议失效日期
    ,sgnchnl varchar2(6) -- 签约渠道
    ,magebrn varchar2(9) -- 管理机构
    ,custtype varchar2(3) -- 客户类型 1-个人 2-对公 3-内部户
    ,contextno varchar2(96) -- 掌银app业务参数中的contextno
    ,custno varchar2(30) -- 客户号
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
grant select on ${iol_schema}.mpcs_a1stacctptcidinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1stacctptcidinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1stacctptcidinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1stacctptcidinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1stacctptcidinfo is '数字货币挂接协议表';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.transdt is '登记日期';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.trntm is '登记时间';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.managementtype is '签约状态 0-解约 1-签约 2-待生效';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.ptcidno is '挂接协议号';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.msgsndcd is '动态关联码';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.msgvrfy is '动态验证码';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sgnacctptyid is '签约人银行账户所属机构';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sgnaccttp is '签约人银行账户类型 at00：个人银行借记账户 at01：个人银行贷记账户 at02：个人银行准贷记账户 at03：单位银行结算账户 at04：基本存款账户 at05：一般存款账户 at06：临时存款账户 at07：dc/ep特殊存款账户';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sgnacctidkey is '签约人银行账户账号';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sgnacctnmkey is '签约人银行账户户名';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.idtype is '签约人证件类型 it01：居民身份证 it02：军官证 it03：护照 it04：户口薄 it05：士兵证 it06：港澳往来内地通行证 it07：台湾同胞来往内地通行证 it08：临时身份证 it09：外国人居留证 it10：警官证 it11：营业执照 it12：组织机构代码 it13：税务登记证 it14：统一社会信用代码证 it15：事业单位法人证书 it16：社会团体法人登记证书 it17：民办非企业单位登记证书 it18: 开户许可通知书 it99：其他';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.idnumberkey is '签约人证件号码';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.telephonekey is '银行预留手机号码';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.waltetptyid is '钱包开立所属机构编码';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.waltetidkey is '钱包id';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.waltettype is '钱包类型 wt01：个人钱包 wt02：子个人钱包 wt03：硬件钱包 wt09：对公钱包 wt10：子对公钱包';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.walletlevel is '钱包等级 wl01：一类钱包 wl02：二类钱包 wl03：三类钱包 wl04：四类钱包';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.fisttlr is '签约柜员';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.recvtlr is '解约柜员';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.fisttime is '签约时间';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.recvtime is '解约时间';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.reflag is '已换卡标识（1 已换卡，0 未换卡）';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.newsgnacctid is '新卡账号';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.chgtime is '换卡时间';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.unsignseqno is '解约流水';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sgnacctptyname is '签约人银行账户所属机构名称';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.waltetptyname is '钱包开立所属机构编码名称';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sndbrn is '发起机构';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.idenduedt is '证件失效日期';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.corprtnnm is '单位名称';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.pckno is '报文类型';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.lglrepnm is '法定代表人或单位负责人姓名';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.lglrepidtp is '法定代表人或单位负责人证件类型';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.lglrepidno is '法定代表人或单位负责人证件号码';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sngltxamtlmt is '单笔兑出业务金额上限';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.dlttlcnt is '日累计兑出业务笔数上限';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.dlttlamtlmt is '日累计兑出业务金额上限';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.anlttlcnt is '年累计兑出业务笔数上限';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.anlttlamtlmt is '年累计兑出业务金额上限';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.ptcfctvdt is '协议生效日期';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.ptcifctvdt is '协议失效日期';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.sgnchnl is '签约渠道';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.custtype is '客户类型 1-个人 2-对公 3-内部户';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.contextno is '掌银app业务参数中的contextno';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1stacctptcidinfo.etl_timestamp is 'ETL处理时间戳';
