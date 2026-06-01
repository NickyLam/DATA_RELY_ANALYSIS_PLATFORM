/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_eaccount_op_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_eaccount_op_data
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_eaccount_op_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_eaccount_op_data(
    peod_accesstoken varchar2(64) -- 调用服务凭证
    ,peod_custno varchar2(32) -- 统一客户号
    ,peod_customername varchar2(120) -- 客户姓名
    ,peod_userno varchar2(32) -- 用户顺序号
    ,peod_contactcertificatetypeid varchar2(4) -- 证件类型
    ,peod_infostring varchar2(100) -- 证件号码
    ,peod_birthdate varchar2(10) -- 出生日期
    ,peod_fromdate varchar2(10) -- 开始有效期
    ,peod_thrudate varchar2(10) -- 证件到期日
    ,peod_authaddrcode varchar2(20) -- 发证机构地区代码
    ,peod_authaddrname varchar2(200) -- 发证机构地区名称
    ,peod_contactnum varchar2(30) -- 手机号码
    ,peod_gender varchar2(1) -- 性别（1-男性2-女性9-未说明性别）
    ,peod_industry varchar2(100) -- 职业
    ,peod_detailaddress varchar2(200) -- 联系地址
    ,peod_taxresident varchar2(1) -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
    ,peod_taxstatement varchar2(1) -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
    ,peod_eaccountno varchar2(32) -- 电子账户
    ,peod_quickbind varchar2(1) -- 是否一键式开户（0：不是一键开户1：是一键开户）
    ,peod_quickbindflag varchar2(1) -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
    ,peod_custflag varchar2(1) -- 是否我行客户(0：非我行客户1：我行客户)
    ,peod_ebankcifisexist varchar2(1) -- 是否网银客户(0：未开通网银1：开通网银)
    ,peod_accountflag varchar2(1) -- 是否已开通Ⅰ类账户(0：否1：是)
    ,peod_eaccountstatus varchar2(1) -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
    ,peod_tranpassword varchar2(512) -- ⅡⅢ类账户交易密码
    ,peod_newlogonpassword varchar2(512) -- 网银登录密码
    ,peod_cardno varchar2(32) -- Ⅰ类账户
    ,peod_otherbankflag varchar2(1) -- Ⅰ类账户本他行标志(0：他行,1：本行)
    ,peod_bankname varchar2(60) -- Ⅰ类账户行名
    ,peod_banknumber varchar2(20) -- Ⅰ类账户行号
    ,peod_financialinstitutioncode varchar2(20) -- 付款卡开户银行金融机构编码
    ,peod_openbranch varchar2(10) -- 开户网点
    ,peod_openbranchname varchar2(200) -- 开户网点名称
    ,peod_recommendationtype varchar2(1) -- 推荐人类型
    ,peod_recommendationnum varchar2(20) -- 推荐人号码
    ,peod_srcsystemid varchar2(3) -- 交易渠道（3位）
    ,peod_channelcode varchar2(6) -- 交易渠道码（4位）
    ,peod_eaccounttype varchar2(20) -- 账户类型
    ,peod_supplyerno varchar2(20) -- 商户编号
    ,peod_supplyername varchar2(200) -- 商户名称
    ,peod_ebankbindflag varchar2(1) -- 是否开通网银标识（0：开通1：不开通默认开通）
    ,peod_threepicverifyflag varchar2(1) -- 人脸识别结果（1识别失败，0识别成功）
    ,peod_channeltype varchar2(10) -- 渠道类型
    ,peod_operatetype varchar2(10) -- 业务类型
    ,peod_accopendate varchar2(14) -- 开户时间
    ,peod_verifychannel varchar2(20) -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
    ,peod_eaccountlevel varchar2(32) -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
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
grant select on ${iol_schema}.osbs_pbs_eaccount_op_data to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_eaccount_op_data to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_eaccount_op_data to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_eaccount_op_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_eaccount_op_data is '电子账户开户信息表';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_accesstoken is '调用服务凭证';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_custno is '统一客户号';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_customername is '客户姓名';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_contactcertificatetypeid is '证件类型';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_infostring is '证件号码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_birthdate is '出生日期';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_fromdate is '开始有效期';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_thrudate is '证件到期日';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_authaddrcode is '发证机构地区代码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_authaddrname is '发证机构地区名称';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_contactnum is '手机号码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_gender is '性别（1-男性2-女性9-未说明性别）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_industry is '职业';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_detailaddress is '联系地址';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_taxresident is '居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_taxstatement is '是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_eaccountno is '电子账户';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_quickbind is '是否一键式开户（0：不是一键开户1：是一键开户）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_quickbindflag is '可否一键式开户（0：不可一键式开户1：可一键式开户）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_custflag is '是否我行客户(0：非我行客户1：我行客户)';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_ebankcifisexist is '是否网银客户(0：未开通网银1：开通网银)';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_accountflag is '是否已开通Ⅰ类账户(0：否1：是)';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_eaccountstatus is '已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_tranpassword is 'ⅡⅢ类账户交易密码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_newlogonpassword is '网银登录密码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_cardno is 'Ⅰ类账户';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_otherbankflag is 'Ⅰ类账户本他行标志(0：他行,1：本行)';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_bankname is 'Ⅰ类账户行名';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_banknumber is 'Ⅰ类账户行号';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_financialinstitutioncode is '付款卡开户银行金融机构编码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_openbranch is '开户网点';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_openbranchname is '开户网点名称';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_recommendationtype is '推荐人类型';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_recommendationnum is '推荐人号码';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_srcsystemid is '交易渠道（3位）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_channelcode is '交易渠道码（4位）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_eaccounttype is '账户类型';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_supplyerno is '商户编号';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_supplyername is '商户名称';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_ebankbindflag is '是否开通网银标识（0：开通1：不开通默认开通）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_threepicverifyflag is '人脸识别结果（1识别失败，0识别成功）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_channeltype is '渠道类型';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_operatetype is '业务类型';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_accopendate is '开户时间';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_verifychannel is '五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.peod_eaccountlevel is '账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_data.etl_timestamp is 'ETL处理时间戳';
