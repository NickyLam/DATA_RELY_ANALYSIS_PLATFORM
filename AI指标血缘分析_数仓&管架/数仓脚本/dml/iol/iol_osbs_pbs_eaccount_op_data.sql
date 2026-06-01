/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_eaccount_op_data
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
create table ${iol_schema}.osbs_pbs_eaccount_op_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_pbs_eaccount_op_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_eaccount_op_data_op purge;
drop table ${iol_schema}.osbs_pbs_eaccount_op_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_eaccount_op_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_eaccount_op_data where 0=1;

create table ${iol_schema}.osbs_pbs_eaccount_op_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_eaccount_op_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_eaccount_op_data_cl(
            peod_accesstoken -- 调用服务凭证
            ,peod_custno -- 统一客户号
            ,peod_customername -- 客户姓名
            ,peod_userno -- 用户顺序号
            ,peod_contactcertificatetypeid -- 证件类型
            ,peod_infostring -- 证件号码
            ,peod_birthdate -- 出生日期
            ,peod_fromdate -- 开始有效期
            ,peod_thrudate -- 证件到期日
            ,peod_authaddrcode -- 发证机构地区代码
            ,peod_authaddrname -- 发证机构地区名称
            ,peod_contactnum -- 手机号码
            ,peod_gender -- 性别（1-男性2-女性9-未说明性别）
            ,peod_industry -- 职业
            ,peod_detailaddress -- 联系地址
            ,peod_taxresident -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
            ,peod_taxstatement -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
            ,peod_eaccountno -- 电子账户
            ,peod_quickbind -- 是否一键式开户（0：不是一键开户1：是一键开户）
            ,peod_quickbindflag -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
            ,peod_custflag -- 是否我行客户(0：非我行客户1：我行客户)
            ,peod_ebankcifisexist -- 是否网银客户(0：未开通网银1：开通网银)
            ,peod_accountflag -- 是否已开通Ⅰ类账户(0：否1：是)
            ,peod_eaccountstatus -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
            ,peod_tranpassword -- ⅡⅢ类账户交易密码
            ,peod_newlogonpassword -- 网银登录密码
            ,peod_cardno -- Ⅰ类账户
            ,peod_otherbankflag -- Ⅰ类账户本他行标志(0：他行,1：本行)
            ,peod_bankname -- Ⅰ类账户行名
            ,peod_banknumber -- Ⅰ类账户行号
            ,peod_financialinstitutioncode -- 付款卡开户银行金融机构编码
            ,peod_openbranch -- 开户网点
            ,peod_openbranchname -- 开户网点名称
            ,peod_recommendationtype -- 推荐人类型
            ,peod_recommendationnum -- 推荐人号码
            ,peod_srcsystemid -- 交易渠道（3位）
            ,peod_channelcode -- 交易渠道码（4位）
            ,peod_eaccounttype -- 账户类型
            ,peod_supplyerno -- 商户编号
            ,peod_supplyername -- 商户名称
            ,peod_ebankbindflag -- 是否开通网银标识（0：开通1：不开通默认开通）
            ,peod_threepicverifyflag -- 人脸识别结果（1识别失败，0识别成功）
            ,peod_channeltype -- 渠道类型
            ,peod_operatetype -- 业务类型
            ,peod_accopendate -- 开户时间
            ,peod_verifychannel -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
            ,peod_eaccountlevel -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_eaccount_op_data_op(
            peod_accesstoken -- 调用服务凭证
            ,peod_custno -- 统一客户号
            ,peod_customername -- 客户姓名
            ,peod_userno -- 用户顺序号
            ,peod_contactcertificatetypeid -- 证件类型
            ,peod_infostring -- 证件号码
            ,peod_birthdate -- 出生日期
            ,peod_fromdate -- 开始有效期
            ,peod_thrudate -- 证件到期日
            ,peod_authaddrcode -- 发证机构地区代码
            ,peod_authaddrname -- 发证机构地区名称
            ,peod_contactnum -- 手机号码
            ,peod_gender -- 性别（1-男性2-女性9-未说明性别）
            ,peod_industry -- 职业
            ,peod_detailaddress -- 联系地址
            ,peod_taxresident -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
            ,peod_taxstatement -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
            ,peod_eaccountno -- 电子账户
            ,peod_quickbind -- 是否一键式开户（0：不是一键开户1：是一键开户）
            ,peod_quickbindflag -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
            ,peod_custflag -- 是否我行客户(0：非我行客户1：我行客户)
            ,peod_ebankcifisexist -- 是否网银客户(0：未开通网银1：开通网银)
            ,peod_accountflag -- 是否已开通Ⅰ类账户(0：否1：是)
            ,peod_eaccountstatus -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
            ,peod_tranpassword -- ⅡⅢ类账户交易密码
            ,peod_newlogonpassword -- 网银登录密码
            ,peod_cardno -- Ⅰ类账户
            ,peod_otherbankflag -- Ⅰ类账户本他行标志(0：他行,1：本行)
            ,peod_bankname -- Ⅰ类账户行名
            ,peod_banknumber -- Ⅰ类账户行号
            ,peod_financialinstitutioncode -- 付款卡开户银行金融机构编码
            ,peod_openbranch -- 开户网点
            ,peod_openbranchname -- 开户网点名称
            ,peod_recommendationtype -- 推荐人类型
            ,peod_recommendationnum -- 推荐人号码
            ,peod_srcsystemid -- 交易渠道（3位）
            ,peod_channelcode -- 交易渠道码（4位）
            ,peod_eaccounttype -- 账户类型
            ,peod_supplyerno -- 商户编号
            ,peod_supplyername -- 商户名称
            ,peod_ebankbindflag -- 是否开通网银标识（0：开通1：不开通默认开通）
            ,peod_threepicverifyflag -- 人脸识别结果（1识别失败，0识别成功）
            ,peod_channeltype -- 渠道类型
            ,peod_operatetype -- 业务类型
            ,peod_accopendate -- 开户时间
            ,peod_verifychannel -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
            ,peod_eaccountlevel -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.peod_accesstoken, o.peod_accesstoken) as peod_accesstoken -- 调用服务凭证
    ,nvl(n.peod_custno, o.peod_custno) as peod_custno -- 统一客户号
    ,nvl(n.peod_customername, o.peod_customername) as peod_customername -- 客户姓名
    ,nvl(n.peod_userno, o.peod_userno) as peod_userno -- 用户顺序号
    ,nvl(n.peod_contactcertificatetypeid, o.peod_contactcertificatetypeid) as peod_contactcertificatetypeid -- 证件类型
    ,nvl(n.peod_infostring, o.peod_infostring) as peod_infostring -- 证件号码
    ,nvl(n.peod_birthdate, o.peod_birthdate) as peod_birthdate -- 出生日期
    ,nvl(n.peod_fromdate, o.peod_fromdate) as peod_fromdate -- 开始有效期
    ,nvl(n.peod_thrudate, o.peod_thrudate) as peod_thrudate -- 证件到期日
    ,nvl(n.peod_authaddrcode, o.peod_authaddrcode) as peod_authaddrcode -- 发证机构地区代码
    ,nvl(n.peod_authaddrname, o.peod_authaddrname) as peod_authaddrname -- 发证机构地区名称
    ,nvl(n.peod_contactnum, o.peod_contactnum) as peod_contactnum -- 手机号码
    ,nvl(n.peod_gender, o.peod_gender) as peod_gender -- 性别（1-男性2-女性9-未说明性别）
    ,nvl(n.peod_industry, o.peod_industry) as peod_industry -- 职业
    ,nvl(n.peod_detailaddress, o.peod_detailaddress) as peod_detailaddress -- 联系地址
    ,nvl(n.peod_taxresident, o.peod_taxresident) as peod_taxresident -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
    ,nvl(n.peod_taxstatement, o.peod_taxstatement) as peod_taxstatement -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
    ,nvl(n.peod_eaccountno, o.peod_eaccountno) as peod_eaccountno -- 电子账户
    ,nvl(n.peod_quickbind, o.peod_quickbind) as peod_quickbind -- 是否一键式开户（0：不是一键开户1：是一键开户）
    ,nvl(n.peod_quickbindflag, o.peod_quickbindflag) as peod_quickbindflag -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
    ,nvl(n.peod_custflag, o.peod_custflag) as peod_custflag -- 是否我行客户(0：非我行客户1：我行客户)
    ,nvl(n.peod_ebankcifisexist, o.peod_ebankcifisexist) as peod_ebankcifisexist -- 是否网银客户(0：未开通网银1：开通网银)
    ,nvl(n.peod_accountflag, o.peod_accountflag) as peod_accountflag -- 是否已开通Ⅰ类账户(0：否1：是)
    ,nvl(n.peod_eaccountstatus, o.peod_eaccountstatus) as peod_eaccountstatus -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
    ,nvl(n.peod_tranpassword, o.peod_tranpassword) as peod_tranpassword -- ⅡⅢ类账户交易密码
    ,nvl(n.peod_newlogonpassword, o.peod_newlogonpassword) as peod_newlogonpassword -- 网银登录密码
    ,nvl(n.peod_cardno, o.peod_cardno) as peod_cardno -- Ⅰ类账户
    ,nvl(n.peod_otherbankflag, o.peod_otherbankflag) as peod_otherbankflag -- Ⅰ类账户本他行标志(0：他行,1：本行)
    ,nvl(n.peod_bankname, o.peod_bankname) as peod_bankname -- Ⅰ类账户行名
    ,nvl(n.peod_banknumber, o.peod_banknumber) as peod_banknumber -- Ⅰ类账户行号
    ,nvl(n.peod_financialinstitutioncode, o.peod_financialinstitutioncode) as peod_financialinstitutioncode -- 付款卡开户银行金融机构编码
    ,nvl(n.peod_openbranch, o.peod_openbranch) as peod_openbranch -- 开户网点
    ,nvl(n.peod_openbranchname, o.peod_openbranchname) as peod_openbranchname -- 开户网点名称
    ,nvl(n.peod_recommendationtype, o.peod_recommendationtype) as peod_recommendationtype -- 推荐人类型
    ,nvl(n.peod_recommendationnum, o.peod_recommendationnum) as peod_recommendationnum -- 推荐人号码
    ,nvl(n.peod_srcsystemid, o.peod_srcsystemid) as peod_srcsystemid -- 交易渠道（3位）
    ,nvl(n.peod_channelcode, o.peod_channelcode) as peod_channelcode -- 交易渠道码（4位）
    ,nvl(n.peod_eaccounttype, o.peod_eaccounttype) as peod_eaccounttype -- 账户类型
    ,nvl(n.peod_supplyerno, o.peod_supplyerno) as peod_supplyerno -- 商户编号
    ,nvl(n.peod_supplyername, o.peod_supplyername) as peod_supplyername -- 商户名称
    ,nvl(n.peod_ebankbindflag, o.peod_ebankbindflag) as peod_ebankbindflag -- 是否开通网银标识（0：开通1：不开通默认开通）
    ,nvl(n.peod_threepicverifyflag, o.peod_threepicverifyflag) as peod_threepicverifyflag -- 人脸识别结果（1识别失败，0识别成功）
    ,nvl(n.peod_channeltype, o.peod_channeltype) as peod_channeltype -- 渠道类型
    ,nvl(n.peod_operatetype, o.peod_operatetype) as peod_operatetype -- 业务类型
    ,nvl(n.peod_accopendate, o.peod_accopendate) as peod_accopendate -- 开户时间
    ,nvl(n.peod_verifychannel, o.peod_verifychannel) as peod_verifychannel -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
    ,nvl(n.peod_eaccountlevel, o.peod_eaccountlevel) as peod_eaccountlevel -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
    ,case when
            n.peod_accesstoken is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.peod_accesstoken is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.peod_accesstoken is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_pbs_eaccount_op_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_pbs_eaccount_op_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.peod_accesstoken = n.peod_accesstoken
where (
        o.peod_accesstoken is null
    )
    or (
        n.peod_accesstoken is null
    )
    or (
        o.peod_custno <> n.peod_custno
        or o.peod_customername <> n.peod_customername
        or o.peod_userno <> n.peod_userno
        or o.peod_contactcertificatetypeid <> n.peod_contactcertificatetypeid
        or o.peod_infostring <> n.peod_infostring
        or o.peod_birthdate <> n.peod_birthdate
        or o.peod_fromdate <> n.peod_fromdate
        or o.peod_thrudate <> n.peod_thrudate
        or o.peod_authaddrcode <> n.peod_authaddrcode
        or o.peod_authaddrname <> n.peod_authaddrname
        or o.peod_contactnum <> n.peod_contactnum
        or o.peod_gender <> n.peod_gender
        or o.peod_industry <> n.peod_industry
        or o.peod_detailaddress <> n.peod_detailaddress
        or o.peod_taxresident <> n.peod_taxresident
        or o.peod_taxstatement <> n.peod_taxstatement
        or o.peod_eaccountno <> n.peod_eaccountno
        or o.peod_quickbind <> n.peod_quickbind
        or o.peod_quickbindflag <> n.peod_quickbindflag
        or o.peod_custflag <> n.peod_custflag
        or o.peod_ebankcifisexist <> n.peod_ebankcifisexist
        or o.peod_accountflag <> n.peod_accountflag
        or o.peod_eaccountstatus <> n.peod_eaccountstatus
        or o.peod_tranpassword <> n.peod_tranpassword
        or o.peod_newlogonpassword <> n.peod_newlogonpassword
        or o.peod_cardno <> n.peod_cardno
        or o.peod_otherbankflag <> n.peod_otherbankflag
        or o.peod_bankname <> n.peod_bankname
        or o.peod_banknumber <> n.peod_banknumber
        or o.peod_financialinstitutioncode <> n.peod_financialinstitutioncode
        or o.peod_openbranch <> n.peod_openbranch
        or o.peod_openbranchname <> n.peod_openbranchname
        or o.peod_recommendationtype <> n.peod_recommendationtype
        or o.peod_recommendationnum <> n.peod_recommendationnum
        or o.peod_srcsystemid <> n.peod_srcsystemid
        or o.peod_channelcode <> n.peod_channelcode
        or o.peod_eaccounttype <> n.peod_eaccounttype
        or o.peod_supplyerno <> n.peod_supplyerno
        or o.peod_supplyername <> n.peod_supplyername
        or o.peod_ebankbindflag <> n.peod_ebankbindflag
        or o.peod_threepicverifyflag <> n.peod_threepicverifyflag
        or o.peod_channeltype <> n.peod_channeltype
        or o.peod_operatetype <> n.peod_operatetype
        or o.peod_accopendate <> n.peod_accopendate
        or o.peod_verifychannel <> n.peod_verifychannel
        or o.peod_eaccountlevel <> n.peod_eaccountlevel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_eaccount_op_data_cl(
            peod_accesstoken -- 调用服务凭证
            ,peod_custno -- 统一客户号
            ,peod_customername -- 客户姓名
            ,peod_userno -- 用户顺序号
            ,peod_contactcertificatetypeid -- 证件类型
            ,peod_infostring -- 证件号码
            ,peod_birthdate -- 出生日期
            ,peod_fromdate -- 开始有效期
            ,peod_thrudate -- 证件到期日
            ,peod_authaddrcode -- 发证机构地区代码
            ,peod_authaddrname -- 发证机构地区名称
            ,peod_contactnum -- 手机号码
            ,peod_gender -- 性别（1-男性2-女性9-未说明性别）
            ,peod_industry -- 职业
            ,peod_detailaddress -- 联系地址
            ,peod_taxresident -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
            ,peod_taxstatement -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
            ,peod_eaccountno -- 电子账户
            ,peod_quickbind -- 是否一键式开户（0：不是一键开户1：是一键开户）
            ,peod_quickbindflag -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
            ,peod_custflag -- 是否我行客户(0：非我行客户1：我行客户)
            ,peod_ebankcifisexist -- 是否网银客户(0：未开通网银1：开通网银)
            ,peod_accountflag -- 是否已开通Ⅰ类账户(0：否1：是)
            ,peod_eaccountstatus -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
            ,peod_tranpassword -- ⅡⅢ类账户交易密码
            ,peod_newlogonpassword -- 网银登录密码
            ,peod_cardno -- Ⅰ类账户
            ,peod_otherbankflag -- Ⅰ类账户本他行标志(0：他行,1：本行)
            ,peod_bankname -- Ⅰ类账户行名
            ,peod_banknumber -- Ⅰ类账户行号
            ,peod_financialinstitutioncode -- 付款卡开户银行金融机构编码
            ,peod_openbranch -- 开户网点
            ,peod_openbranchname -- 开户网点名称
            ,peod_recommendationtype -- 推荐人类型
            ,peod_recommendationnum -- 推荐人号码
            ,peod_srcsystemid -- 交易渠道（3位）
            ,peod_channelcode -- 交易渠道码（4位）
            ,peod_eaccounttype -- 账户类型
            ,peod_supplyerno -- 商户编号
            ,peod_supplyername -- 商户名称
            ,peod_ebankbindflag -- 是否开通网银标识（0：开通1：不开通默认开通）
            ,peod_threepicverifyflag -- 人脸识别结果（1识别失败，0识别成功）
            ,peod_channeltype -- 渠道类型
            ,peod_operatetype -- 业务类型
            ,peod_accopendate -- 开户时间
            ,peod_verifychannel -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
            ,peod_eaccountlevel -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_eaccount_op_data_op(
            peod_accesstoken -- 调用服务凭证
            ,peod_custno -- 统一客户号
            ,peod_customername -- 客户姓名
            ,peod_userno -- 用户顺序号
            ,peod_contactcertificatetypeid -- 证件类型
            ,peod_infostring -- 证件号码
            ,peod_birthdate -- 出生日期
            ,peod_fromdate -- 开始有效期
            ,peod_thrudate -- 证件到期日
            ,peod_authaddrcode -- 发证机构地区代码
            ,peod_authaddrname -- 发证机构地区名称
            ,peod_contactnum -- 手机号码
            ,peod_gender -- 性别（1-男性2-女性9-未说明性别）
            ,peod_industry -- 职业
            ,peod_detailaddress -- 联系地址
            ,peod_taxresident -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
            ,peod_taxstatement -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
            ,peod_eaccountno -- 电子账户
            ,peod_quickbind -- 是否一键式开户（0：不是一键开户1：是一键开户）
            ,peod_quickbindflag -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
            ,peod_custflag -- 是否我行客户(0：非我行客户1：我行客户)
            ,peod_ebankcifisexist -- 是否网银客户(0：未开通网银1：开通网银)
            ,peod_accountflag -- 是否已开通Ⅰ类账户(0：否1：是)
            ,peod_eaccountstatus -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
            ,peod_tranpassword -- ⅡⅢ类账户交易密码
            ,peod_newlogonpassword -- 网银登录密码
            ,peod_cardno -- Ⅰ类账户
            ,peod_otherbankflag -- Ⅰ类账户本他行标志(0：他行,1：本行)
            ,peod_bankname -- Ⅰ类账户行名
            ,peod_banknumber -- Ⅰ类账户行号
            ,peod_financialinstitutioncode -- 付款卡开户银行金融机构编码
            ,peod_openbranch -- 开户网点
            ,peod_openbranchname -- 开户网点名称
            ,peod_recommendationtype -- 推荐人类型
            ,peod_recommendationnum -- 推荐人号码
            ,peod_srcsystemid -- 交易渠道（3位）
            ,peod_channelcode -- 交易渠道码（4位）
            ,peod_eaccounttype -- 账户类型
            ,peod_supplyerno -- 商户编号
            ,peod_supplyername -- 商户名称
            ,peod_ebankbindflag -- 是否开通网银标识（0：开通1：不开通默认开通）
            ,peod_threepicverifyflag -- 人脸识别结果（1识别失败，0识别成功）
            ,peod_channeltype -- 渠道类型
            ,peod_operatetype -- 业务类型
            ,peod_accopendate -- 开户时间
            ,peod_verifychannel -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
            ,peod_eaccountlevel -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.peod_accesstoken -- 调用服务凭证
    ,o.peod_custno -- 统一客户号
    ,o.peod_customername -- 客户姓名
    ,o.peod_userno -- 用户顺序号
    ,o.peod_contactcertificatetypeid -- 证件类型
    ,o.peod_infostring -- 证件号码
    ,o.peod_birthdate -- 出生日期
    ,o.peod_fromdate -- 开始有效期
    ,o.peod_thrudate -- 证件到期日
    ,o.peod_authaddrcode -- 发证机构地区代码
    ,o.peod_authaddrname -- 发证机构地区名称
    ,o.peod_contactnum -- 手机号码
    ,o.peod_gender -- 性别（1-男性2-女性9-未说明性别）
    ,o.peod_industry -- 职业
    ,o.peod_detailaddress -- 联系地址
    ,o.peod_taxresident -- 居民税收标识(1：仅为中国税收居民2：仅为非居民3：既是中国税收居民又是其他国家（地区）税收居民4：无需声明5：空)
    ,o.peod_taxstatement -- 是否取得自证声明(税收居民)（0：未取得自证声明1：取得自证声明）
    ,o.peod_eaccountno -- 电子账户
    ,o.peod_quickbind -- 是否一键式开户（0：不是一键开户1：是一键开户）
    ,o.peod_quickbindflag -- 可否一键式开户（0：不可一键式开户1：可一键式开户）
    ,o.peod_custflag -- 是否我行客户(0：非我行客户1：我行客户)
    ,o.peod_ebankcifisexist -- 是否网银客户(0：未开通网银1：开通网银)
    ,o.peod_accountflag -- 是否已开通Ⅰ类账户(0：否1：是)
    ,o.peod_eaccountstatus -- 已开通ⅡⅢ类账户状态(0：e账号正常/冻结,2：未开通二类户,1/3：其他需要重新开户的状态  对应零钱包)
    ,o.peod_tranpassword -- ⅡⅢ类账户交易密码
    ,o.peod_newlogonpassword -- 网银登录密码
    ,o.peod_cardno -- Ⅰ类账户
    ,o.peod_otherbankflag -- Ⅰ类账户本他行标志(0：他行,1：本行)
    ,o.peod_bankname -- Ⅰ类账户行名
    ,o.peod_banknumber -- Ⅰ类账户行号
    ,o.peod_financialinstitutioncode -- 付款卡开户银行金融机构编码
    ,o.peod_openbranch -- 开户网点
    ,o.peod_openbranchname -- 开户网点名称
    ,o.peod_recommendationtype -- 推荐人类型
    ,o.peod_recommendationnum -- 推荐人号码
    ,o.peod_srcsystemid -- 交易渠道（3位）
    ,o.peod_channelcode -- 交易渠道码（4位）
    ,o.peod_eaccounttype -- 账户类型
    ,o.peod_supplyerno -- 商户编号
    ,o.peod_supplyername -- 商户名称
    ,o.peod_ebankbindflag -- 是否开通网银标识（0：开通1：不开通默认开通）
    ,o.peod_threepicverifyflag -- 人脸识别结果（1识别失败，0识别成功）
    ,o.peod_channeltype -- 渠道类型
    ,o.peod_operatetype -- 业务类型
    ,o.peod_accopendate -- 开户时间
    ,o.peod_verifychannel -- 五要素验证通道（BANK_INSIDE-本行卡、CUPS-中国银联）
    ,o.peod_eaccountlevel -- 账户等级:FIRST-ACCT：I类户;SECOND-ACCT：II类户;THIRD-ACCT：III类户;TEMP-ACCT：临时户;VIRTUAL-ACCT：虚拟户
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
from ${iol_schema}.osbs_pbs_eaccount_op_data_bk o
    left join ${iol_schema}.osbs_pbs_eaccount_op_data_op n
        on
            o.peod_accesstoken = n.peod_accesstoken
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_pbs_eaccount_op_data_cl d
        on
            o.peod_accesstoken = d.peod_accesstoken
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_pbs_eaccount_op_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_pbs_eaccount_op_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_pbs_eaccount_op_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_pbs_eaccount_op_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_pbs_eaccount_op_data exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_eaccount_op_data_cl;
alter table ${iol_schema}.osbs_pbs_eaccount_op_data exchange partition p_20991231 with table ${iol_schema}.osbs_pbs_eaccount_op_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_eaccount_op_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_eaccount_op_data_op purge;
drop table ${iol_schema}.osbs_pbs_eaccount_op_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_pbs_eaccount_op_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_eaccount_op_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
