/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_asset_pool
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_asset_pool
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_asset_pool purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_asset_pool(
    assetpoolno varchar2(60) -- 资产池编号
    ,assetpoolname varchar2(150) -- 资产池名称
    ,parentassetpoolno varchar2(60) -- 父资产池编号
    ,assetpooltype varchar2(27) -- 资产池类型
    ,assetpoolnature varchar2(27) -- 资产池性质
    ,assetpoolstatus varchar2(27) -- 资产池状态
    ,packetflag varchar2(2) -- 是否封包
    ,packetdate varchar2(36) -- 封包日
    ,transferdate varchar2(36) -- 转让日
    ,collectiondate varchar2(36) -- 收款日
    ,packetnum number(22,0) -- 封包日数量
    ,packetsize number(24,6) -- 封包日规模
    ,transferprin number(24,6) -- 转让日本金
    ,collectionprin number(24,6) -- 收款日本金
    ,actualcollection number(24,6) -- 实际收款
    ,assetpoolsize number(24,6) -- 资产池规模
    ,updateuserid varchar2(60) -- 更新人ID
    ,updateorgid varchar2(60) -- 更新机构ID
    ,updatetime varchar2(36) -- 更新时间
    ,unpacketdate varchar2(36) -- 解包日
    ,finishtype varchar2(15) -- 终结类型
    ,finishdate varchar2(36) -- 终结日期
    ,newpacketassetcount number(10,0) -- 新增封包申请时资产个数
    ,arearatio varchar2(60) -- 区域集中度筛选
    ,industryratio varchar2(60) -- 行业集中度
    ,currency varchar2(15) -- 币种
    ,inputuserid varchar2(60) -- 登记人
    ,inputorgid varchar2(60) -- 登记机构
    ,inputtime varchar2(36) -- 登记时间
    ,packetaccsize number(24,2) -- 封包日累计规模
    ,packetaccnum number(22,0) -- 资产池累计资产个数
    ,collectionaccountname varchar2(300) -- 收款账户名称
    ,collectionaccountid varchar2(60) -- 收款账户账号
    ,collectionaccountorgid varchar2(60) -- 收款账户所属机构
    ,recollectionaccountname varchar2(300) -- 回款归集账户名称
    ,recollectionaccountid varchar2(60) -- 回款归集账户账号
    ,recollectionaccountorgid varchar2(60) -- 回款归集账户所属机构
    ,packetwaremamaturity number(12,0) -- 封包时加权剩余期限
    ,packetwarate number(12,6) -- 封包时加权平均利率
    ,accruedchargedate varchar2(36) -- 费用计提日
    ,totalassetpoolsize number(24,2) -- 实时资产池规模
    ,isbad varchar2(2) -- 不良资产标志
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
grant select on ${iol_schema}.abss_abs_asset_pool to ${iml_schema};
grant select on ${iol_schema}.abss_abs_asset_pool to ${icl_schema};
grant select on ${iol_schema}.abss_abs_asset_pool to ${idl_schema};
grant select on ${iol_schema}.abss_abs_asset_pool to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_asset_pool is '资产池信息表';
comment on column ${iol_schema}.abss_abs_asset_pool.assetpoolno is '资产池编号';
comment on column ${iol_schema}.abss_abs_asset_pool.assetpoolname is '资产池名称';
comment on column ${iol_schema}.abss_abs_asset_pool.parentassetpoolno is '父资产池编号';
comment on column ${iol_schema}.abss_abs_asset_pool.assetpooltype is '资产池类型';
comment on column ${iol_schema}.abss_abs_asset_pool.assetpoolnature is '资产池性质';
comment on column ${iol_schema}.abss_abs_asset_pool.assetpoolstatus is '资产池状态';
comment on column ${iol_schema}.abss_abs_asset_pool.packetflag is '是否封包';
comment on column ${iol_schema}.abss_abs_asset_pool.packetdate is '封包日';
comment on column ${iol_schema}.abss_abs_asset_pool.transferdate is '转让日';
comment on column ${iol_schema}.abss_abs_asset_pool.collectiondate is '收款日';
comment on column ${iol_schema}.abss_abs_asset_pool.packetnum is '封包日数量';
comment on column ${iol_schema}.abss_abs_asset_pool.packetsize is '封包日规模';
comment on column ${iol_schema}.abss_abs_asset_pool.transferprin is '转让日本金';
comment on column ${iol_schema}.abss_abs_asset_pool.collectionprin is '收款日本金';
comment on column ${iol_schema}.abss_abs_asset_pool.actualcollection is '实际收款';
comment on column ${iol_schema}.abss_abs_asset_pool.assetpoolsize is '资产池规模';
comment on column ${iol_schema}.abss_abs_asset_pool.updateuserid is '更新人ID';
comment on column ${iol_schema}.abss_abs_asset_pool.updateorgid is '更新机构ID';
comment on column ${iol_schema}.abss_abs_asset_pool.updatetime is '更新时间';
comment on column ${iol_schema}.abss_abs_asset_pool.unpacketdate is '解包日';
comment on column ${iol_schema}.abss_abs_asset_pool.finishtype is '终结类型';
comment on column ${iol_schema}.abss_abs_asset_pool.finishdate is '终结日期';
comment on column ${iol_schema}.abss_abs_asset_pool.newpacketassetcount is '新增封包申请时资产个数';
comment on column ${iol_schema}.abss_abs_asset_pool.arearatio is '区域集中度筛选';
comment on column ${iol_schema}.abss_abs_asset_pool.industryratio is '行业集中度';
comment on column ${iol_schema}.abss_abs_asset_pool.currency is '币种';
comment on column ${iol_schema}.abss_abs_asset_pool.inputuserid is '登记人';
comment on column ${iol_schema}.abss_abs_asset_pool.inputorgid is '登记机构';
comment on column ${iol_schema}.abss_abs_asset_pool.inputtime is '登记时间';
comment on column ${iol_schema}.abss_abs_asset_pool.packetaccsize is '封包日累计规模';
comment on column ${iol_schema}.abss_abs_asset_pool.packetaccnum is '资产池累计资产个数';
comment on column ${iol_schema}.abss_abs_asset_pool.collectionaccountname is '收款账户名称';
comment on column ${iol_schema}.abss_abs_asset_pool.collectionaccountid is '收款账户账号';
comment on column ${iol_schema}.abss_abs_asset_pool.collectionaccountorgid is '收款账户所属机构';
comment on column ${iol_schema}.abss_abs_asset_pool.recollectionaccountname is '回款归集账户名称';
comment on column ${iol_schema}.abss_abs_asset_pool.recollectionaccountid is '回款归集账户账号';
comment on column ${iol_schema}.abss_abs_asset_pool.recollectionaccountorgid is '回款归集账户所属机构';
comment on column ${iol_schema}.abss_abs_asset_pool.packetwaremamaturity is '封包时加权剩余期限';
comment on column ${iol_schema}.abss_abs_asset_pool.packetwarate is '封包时加权平均利率';
comment on column ${iol_schema}.abss_abs_asset_pool.accruedchargedate is '费用计提日';
comment on column ${iol_schema}.abss_abs_asset_pool.totalassetpoolsize is '实时资产池规模';
comment on column ${iol_schema}.abss_abs_asset_pool.isbad is '不良资产标志';
comment on column ${iol_schema}.abss_abs_asset_pool.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_asset_pool.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_asset_pool.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_asset_pool.etl_timestamp is 'ETL处理时间戳';
