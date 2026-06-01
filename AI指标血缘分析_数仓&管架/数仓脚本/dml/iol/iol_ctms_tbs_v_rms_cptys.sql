/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_rms_cptys
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
create table ${iol_schema}.ctms_tbs_v_rms_cptys_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_rms_cptys;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_op purge;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_rms_cptys_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_rms_cptys where 0=1;

create table ${iol_schema}.ctms_tbs_v_rms_cptys_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_rms_cptys where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_rms_cptys_cl(
            entyid -- 交易对手编号
            ,pentyid -- 父机构编号
            ,cmscounterpartyid -- 对手id(cms)
            ,fmscounterpartyid -- 对手id(xms)
            ,status -- 状态
            ,ename -- 英文名称
            ,sname -- 中文短名
            ,esname -- 英文短名
            ,contactname -- 法人
            ,telephone -- 电话
            ,fax -- 传真
            ,label -- 其他系统代号
            ,fdistid -- 所在地区编号
            ,customertype -- 行业类别编号
            ,ratinglevel -- 内部信用评级
            ,ratinglevelname -- 内部信用评级名称
            ,excode -- 电子联行号
            ,exaccount -- 大额支付系统号
            ,trdpartcode -- 第三方代码
            ,swiftcode -- swift电文代号
            ,refissuerid -- 发行/担保人
            ,isissuer -- 是否发行人
            ,isbank -- 是否金融机构
            ,isguarantee -- 是否担保人
            ,iscustody -- 是否托管机构
            ,cfetsmemberid -- 本币会员id
            ,cfetsfxmemberid -- 外汇会员id
            ,cfetsmemberattr -- 会员来源
            ,entitytype -- 是否母公司
            ,groupid -- 母公司群组编号
            ,branchid -- 用户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_rms_cptys_op(
            entyid -- 交易对手编号
            ,pentyid -- 父机构编号
            ,cmscounterpartyid -- 对手id(cms)
            ,fmscounterpartyid -- 对手id(xms)
            ,status -- 状态
            ,ename -- 英文名称
            ,sname -- 中文短名
            ,esname -- 英文短名
            ,contactname -- 法人
            ,telephone -- 电话
            ,fax -- 传真
            ,label -- 其他系统代号
            ,fdistid -- 所在地区编号
            ,customertype -- 行业类别编号
            ,ratinglevel -- 内部信用评级
            ,ratinglevelname -- 内部信用评级名称
            ,excode -- 电子联行号
            ,exaccount -- 大额支付系统号
            ,trdpartcode -- 第三方代码
            ,swiftcode -- swift电文代号
            ,refissuerid -- 发行/担保人
            ,isissuer -- 是否发行人
            ,isbank -- 是否金融机构
            ,isguarantee -- 是否担保人
            ,iscustody -- 是否托管机构
            ,cfetsmemberid -- 本币会员id
            ,cfetsfxmemberid -- 外汇会员id
            ,cfetsmemberattr -- 会员来源
            ,entitytype -- 是否母公司
            ,groupid -- 母公司群组编号
            ,branchid -- 用户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.entyid, o.entyid) as entyid -- 交易对手编号
    ,nvl(n.pentyid, o.pentyid) as pentyid -- 父机构编号
    ,nvl(n.cmscounterpartyid, o.cmscounterpartyid) as cmscounterpartyid -- 对手id(cms)
    ,nvl(n.fmscounterpartyid, o.fmscounterpartyid) as fmscounterpartyid -- 对手id(xms)
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.ename, o.ename) as ename -- 英文名称
    ,nvl(n.sname, o.sname) as sname -- 中文短名
    ,nvl(n.esname, o.esname) as esname -- 英文短名
    ,nvl(n.contactname, o.contactname) as contactname -- 法人
    ,nvl(n.telephone, o.telephone) as telephone -- 电话
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.label, o.label) as label -- 其他系统代号
    ,nvl(n.fdistid, o.fdistid) as fdistid -- 所在地区编号
    ,nvl(n.customertype, o.customertype) as customertype -- 行业类别编号
    ,nvl(n.ratinglevel, o.ratinglevel) as ratinglevel -- 内部信用评级
    ,nvl(n.ratinglevelname, o.ratinglevelname) as ratinglevelname -- 内部信用评级名称
    ,nvl(n.excode, o.excode) as excode -- 电子联行号
    ,nvl(n.exaccount, o.exaccount) as exaccount -- 大额支付系统号
    ,nvl(n.trdpartcode, o.trdpartcode) as trdpartcode -- 第三方代码
    ,nvl(n.swiftcode, o.swiftcode) as swiftcode -- swift电文代号
    ,nvl(n.refissuerid, o.refissuerid) as refissuerid -- 发行/担保人
    ,nvl(n.isissuer, o.isissuer) as isissuer -- 是否发行人
    ,nvl(n.isbank, o.isbank) as isbank -- 是否金融机构
    ,nvl(n.isguarantee, o.isguarantee) as isguarantee -- 是否担保人
    ,nvl(n.iscustody, o.iscustody) as iscustody -- 是否托管机构
    ,nvl(n.cfetsmemberid, o.cfetsmemberid) as cfetsmemberid -- 本币会员id
    ,nvl(n.cfetsfxmemberid, o.cfetsfxmemberid) as cfetsfxmemberid -- 外汇会员id
    ,nvl(n.cfetsmemberattr, o.cfetsmemberattr) as cfetsmemberattr -- 会员来源
    ,nvl(n.entitytype, o.entitytype) as entitytype -- 是否母公司
    ,nvl(n.groupid, o.groupid) as groupid -- 母公司群组编号
    ,nvl(n.branchid, o.branchid) as branchid -- 用户机构编号
    ,case when
            n.entyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.entyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.entyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_rms_cptys_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_rms_cptys where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.entyid = n.entyid
where (
        o.entyid is null
    )
    or (
        n.entyid is null
    )
    or (
        o.pentyid <> n.pentyid
        or o.cmscounterpartyid <> n.cmscounterpartyid
        or o.fmscounterpartyid <> n.fmscounterpartyid
        or o.status <> n.status
        or o.ename <> n.ename
        or o.sname <> n.sname
        or o.esname <> n.esname
        or o.contactname <> n.contactname
        or o.telephone <> n.telephone
        or o.fax <> n.fax
        or o.label <> n.label
        or o.fdistid <> n.fdistid
        or o.customertype <> n.customertype
        or o.ratinglevel <> n.ratinglevel
        or o.ratinglevelname <> n.ratinglevelname
        or o.excode <> n.excode
        or o.exaccount <> n.exaccount
        or o.trdpartcode <> n.trdpartcode
        or o.swiftcode <> n.swiftcode
        or o.refissuerid <> n.refissuerid
        or o.isissuer <> n.isissuer
        or o.isbank <> n.isbank
        or o.isguarantee <> n.isguarantee
        or o.iscustody <> n.iscustody
        or o.cfetsmemberid <> n.cfetsmemberid
        or o.cfetsfxmemberid <> n.cfetsfxmemberid
        or o.cfetsmemberattr <> n.cfetsmemberattr
        or o.entitytype <> n.entitytype
        or o.groupid <> n.groupid
        or o.branchid <> n.branchid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_rms_cptys_cl(
            entyid -- 交易对手编号
            ,pentyid -- 父机构编号
            ,cmscounterpartyid -- 对手id(cms)
            ,fmscounterpartyid -- 对手id(xms)
            ,status -- 状态
            ,ename -- 英文名称
            ,sname -- 中文短名
            ,esname -- 英文短名
            ,contactname -- 法人
            ,telephone -- 电话
            ,fax -- 传真
            ,label -- 其他系统代号
            ,fdistid -- 所在地区编号
            ,customertype -- 行业类别编号
            ,ratinglevel -- 内部信用评级
            ,ratinglevelname -- 内部信用评级名称
            ,excode -- 电子联行号
            ,exaccount -- 大额支付系统号
            ,trdpartcode -- 第三方代码
            ,swiftcode -- swift电文代号
            ,refissuerid -- 发行/担保人
            ,isissuer -- 是否发行人
            ,isbank -- 是否金融机构
            ,isguarantee -- 是否担保人
            ,iscustody -- 是否托管机构
            ,cfetsmemberid -- 本币会员id
            ,cfetsfxmemberid -- 外汇会员id
            ,cfetsmemberattr -- 会员来源
            ,entitytype -- 是否母公司
            ,groupid -- 母公司群组编号
            ,branchid -- 用户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_rms_cptys_op(
            entyid -- 交易对手编号
            ,pentyid -- 父机构编号
            ,cmscounterpartyid -- 对手id(cms)
            ,fmscounterpartyid -- 对手id(xms)
            ,status -- 状态
            ,ename -- 英文名称
            ,sname -- 中文短名
            ,esname -- 英文短名
            ,contactname -- 法人
            ,telephone -- 电话
            ,fax -- 传真
            ,label -- 其他系统代号
            ,fdistid -- 所在地区编号
            ,customertype -- 行业类别编号
            ,ratinglevel -- 内部信用评级
            ,ratinglevelname -- 内部信用评级名称
            ,excode -- 电子联行号
            ,exaccount -- 大额支付系统号
            ,trdpartcode -- 第三方代码
            ,swiftcode -- swift电文代号
            ,refissuerid -- 发行/担保人
            ,isissuer -- 是否发行人
            ,isbank -- 是否金融机构
            ,isguarantee -- 是否担保人
            ,iscustody -- 是否托管机构
            ,cfetsmemberid -- 本币会员id
            ,cfetsfxmemberid -- 外汇会员id
            ,cfetsmemberattr -- 会员来源
            ,entitytype -- 是否母公司
            ,groupid -- 母公司群组编号
            ,branchid -- 用户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.entyid -- 交易对手编号
    ,o.pentyid -- 父机构编号
    ,o.cmscounterpartyid -- 对手id(cms)
    ,o.fmscounterpartyid -- 对手id(xms)
    ,o.status -- 状态
    ,o.ename -- 英文名称
    ,o.sname -- 中文短名
    ,o.esname -- 英文短名
    ,o.contactname -- 法人
    ,o.telephone -- 电话
    ,o.fax -- 传真
    ,o.label -- 其他系统代号
    ,o.fdistid -- 所在地区编号
    ,o.customertype -- 行业类别编号
    ,o.ratinglevel -- 内部信用评级
    ,o.ratinglevelname -- 内部信用评级名称
    ,o.excode -- 电子联行号
    ,o.exaccount -- 大额支付系统号
    ,o.trdpartcode -- 第三方代码
    ,o.swiftcode -- swift电文代号
    ,o.refissuerid -- 发行/担保人
    ,o.isissuer -- 是否发行人
    ,o.isbank -- 是否金融机构
    ,o.isguarantee -- 是否担保人
    ,o.iscustody -- 是否托管机构
    ,o.cfetsmemberid -- 本币会员id
    ,o.cfetsfxmemberid -- 外汇会员id
    ,o.cfetsmemberattr -- 会员来源
    ,o.entitytype -- 是否母公司
    ,o.groupid -- 母公司群组编号
    ,o.branchid -- 用户机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_rms_cptys_bk o
    left join ${iol_schema}.ctms_tbs_v_rms_cptys_op n
        on
            o.entyid = n.entyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_rms_cptys_cl d
        on
            o.entyid = d.entyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_rms_cptys;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_rms_cptys exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_rms_cptys_cl;
alter table ${iol_schema}.ctms_tbs_v_rms_cptys exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_rms_cptys_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_rms_cptys to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_op purge;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_rms_cptys',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
