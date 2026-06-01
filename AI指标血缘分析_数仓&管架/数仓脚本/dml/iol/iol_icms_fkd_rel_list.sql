/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_rel_list
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
create table ${iol_schema}.icms_fkd_rel_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_rel_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_rel_list_op purge;
drop table ${iol_schema}.icms_fkd_rel_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_rel_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_rel_list where 0=1;

create table ${iol_schema}.icms_fkd_rel_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_rel_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_rel_list_cl(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,reltyp -- 关联人类型
            ,relname -- 关联人姓名
            ,reltelno -- 关联人手机号码
            ,relidtype -- 关联人证件类型
            ,relidno -- 关联人证件号码
            ,relrelationship -- 与主借款人关系
            ,relfamilycityid -- 关联人居住地址城市编号
            ,relfamilyaddr -- 关联人居住地址
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,relpartnertelno -- 关联人配偶手机号码
            ,relpartneridtype -- 关联人配偶证件类型
            ,relpartneridno -- 关联人配偶证件号码
            ,cusid -- 客户号
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,remark -- 备注
            ,updatedate -- 更新时间
            ,naturecategoryrel -- 关联人户籍性质
            ,eduexperiencerel -- 关联人学历
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,oblityp -- 智贷去权利人类型
            ,pledgepkno -- 智贷质押物信息主键
            ,conshr -- 智贷权利人共有份额
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,relidexpire -- 关联人证件到期日
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,relnation -- 关联人国籍
            ,relcareer -- 关联人职业
            ,relsex -- 关联人性别
            ,relcareercomm -- 关联人职业备注信息
            ,relpartneridexpire -- 关联人配偶证件失效日期
            ,relpartnernation -- 关联人配偶国籍
            ,relpartnercareer -- 关联人配偶职业
            ,relpartnersex -- 关联人配偶性别
            ,relpartneraddr -- 关联人配偶居住地址
            ,relpartnercareercomm -- 关联人配偶职业备注信息
            ,relideffective -- 
            ,taxqueryflag -- 
            ,taxauthorizeno -- 
            ,taxpayeridentityno -- 
            ,coboinvtstkperc -- 
            ,relannualincome -- 
            ,relauthorizerroleflag -- 
            ,wthrguart -- 
            ,isrelatemaxentholder -- 
            ,relationship -- 
            ,relcorpname -- 
            ,relcorpprop -- 
            ,relemplmyears -- 
            ,relcorpadr -- 
            ,relcorptel -- 
            ,reltaxaftermonincome -- 
            ,relethnic -- 
            ,relresiadr -- 
            ,relwthrhouse -- 
            ,relsocscrcontsmont -- 
            ,relfundcontsmont -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_rel_list_op(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,reltyp -- 关联人类型
            ,relname -- 关联人姓名
            ,reltelno -- 关联人手机号码
            ,relidtype -- 关联人证件类型
            ,relidno -- 关联人证件号码
            ,relrelationship -- 与主借款人关系
            ,relfamilycityid -- 关联人居住地址城市编号
            ,relfamilyaddr -- 关联人居住地址
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,relpartnertelno -- 关联人配偶手机号码
            ,relpartneridtype -- 关联人配偶证件类型
            ,relpartneridno -- 关联人配偶证件号码
            ,cusid -- 客户号
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,remark -- 备注
            ,updatedate -- 更新时间
            ,naturecategoryrel -- 关联人户籍性质
            ,eduexperiencerel -- 关联人学历
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,oblityp -- 智贷去权利人类型
            ,pledgepkno -- 智贷质押物信息主键
            ,conshr -- 智贷权利人共有份额
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,relidexpire -- 关联人证件到期日
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,relnation -- 关联人国籍
            ,relcareer -- 关联人职业
            ,relsex -- 关联人性别
            ,relcareercomm -- 关联人职业备注信息
            ,relpartneridexpire -- 关联人配偶证件失效日期
            ,relpartnernation -- 关联人配偶国籍
            ,relpartnercareer -- 关联人配偶职业
            ,relpartnersex -- 关联人配偶性别
            ,relpartneraddr -- 关联人配偶居住地址
            ,relpartnercareercomm -- 关联人配偶职业备注信息
            ,relideffective -- 
            ,taxqueryflag -- 
            ,taxauthorizeno -- 
            ,taxpayeridentityno -- 
            ,coboinvtstkperc -- 
            ,relannualincome -- 
            ,relauthorizerroleflag -- 
            ,wthrguart -- 
            ,isrelatemaxentholder -- 
            ,relationship -- 
            ,relcorpname -- 
            ,relcorpprop -- 
            ,relemplmyears -- 
            ,relcorpadr -- 
            ,relcorptel -- 
            ,reltaxaftermonincome -- 
            ,relethnic -- 
            ,relresiadr -- 
            ,relwthrhouse -- 
            ,relsocscrcontsmont -- 
            ,relfundcontsmont -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 业务流水号
    ,nvl(n.reltyp, o.reltyp) as reltyp -- 关联人类型
    ,nvl(n.relname, o.relname) as relname -- 关联人姓名
    ,nvl(n.reltelno, o.reltelno) as reltelno -- 关联人手机号码
    ,nvl(n.relidtype, o.relidtype) as relidtype -- 关联人证件类型
    ,nvl(n.relidno, o.relidno) as relidno -- 关联人证件号码
    ,nvl(n.relrelationship, o.relrelationship) as relrelationship -- 与主借款人关系
    ,nvl(n.relfamilycityid, o.relfamilycityid) as relfamilycityid -- 关联人居住地址城市编号
    ,nvl(n.relfamilyaddr, o.relfamilyaddr) as relfamilyaddr -- 关联人居住地址
    ,nvl(n.relmarriage, o.relmarriage) as relmarriage -- 关联人婚姻状况
    ,nvl(n.relpartnername, o.relpartnername) as relpartnername -- 关联人配偶姓名
    ,nvl(n.relpartnertelno, o.relpartnertelno) as relpartnertelno -- 关联人配偶手机号码
    ,nvl(n.relpartneridtype, o.relpartneridtype) as relpartneridtype -- 关联人配偶证件类型
    ,nvl(n.relpartneridno, o.relpartneridno) as relpartneridno -- 关联人配偶证件号码
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.fqzresult, o.fqzresult) as fqzresult -- 反欺诈结果
    ,nvl(n.zxresult, o.zxresult) as zxresult -- 征信结果
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.naturecategoryrel, o.naturecategoryrel) as naturecategoryrel -- 关联人户籍性质
    ,nvl(n.eduexperiencerel, o.eduexperiencerel) as eduexperiencerel -- 关联人学历
    ,nvl(n.ownshare, o.ownshare) as ownshare -- 抵押人对抵押物拥有的份额
    ,nvl(n.agriflg, o.agriflg) as agriflg -- 是否农户
    ,nvl(n.businessesflag, o.businessesflag) as businessesflag -- 客户性质
    ,nvl(n.oblityp, o.oblityp) as oblityp -- 智贷去权利人类型
    ,nvl(n.pledgepkno, o.pledgepkno) as pledgepkno -- 智贷质押物信息主键
    ,nvl(n.conshr, o.conshr) as conshr -- 智贷权利人共有份额
    ,nvl(n.immovables, o.immovables) as immovables -- 不动产共有情况
    ,nvl(n.naturecategoryrelsps, o.naturecategoryrelsps) as naturecategoryrelsps -- 关联人配偶户籍性质
    ,nvl(n.relidexpire, o.relidexpire) as relidexpire -- 关联人证件到期日
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.relnation, o.relnation) as relnation -- 关联人国籍
    ,nvl(n.relcareer, o.relcareer) as relcareer -- 关联人职业
    ,nvl(n.relsex, o.relsex) as relsex -- 关联人性别
    ,nvl(n.relcareercomm, o.relcareercomm) as relcareercomm -- 关联人职业备注信息
    ,nvl(n.relpartneridexpire, o.relpartneridexpire) as relpartneridexpire -- 关联人配偶证件失效日期
    ,nvl(n.relpartnernation, o.relpartnernation) as relpartnernation -- 关联人配偶国籍
    ,nvl(n.relpartnercareer, o.relpartnercareer) as relpartnercareer -- 关联人配偶职业
    ,nvl(n.relpartnersex, o.relpartnersex) as relpartnersex -- 关联人配偶性别
    ,nvl(n.relpartneraddr, o.relpartneraddr) as relpartneraddr -- 关联人配偶居住地址
    ,nvl(n.relpartnercareercomm, o.relpartnercareercomm) as relpartnercareercomm -- 关联人配偶职业备注信息
    ,nvl(n.relideffective, o.relideffective) as relideffective -- 
    ,nvl(n.taxqueryflag, o.taxqueryflag) as taxqueryflag -- 
    ,nvl(n.taxauthorizeno, o.taxauthorizeno) as taxauthorizeno -- 
    ,nvl(n.taxpayeridentityno, o.taxpayeridentityno) as taxpayeridentityno -- 
    ,nvl(n.coboinvtstkperc, o.coboinvtstkperc) as coboinvtstkperc -- 
    ,nvl(n.relannualincome, o.relannualincome) as relannualincome -- 
    ,nvl(n.relauthorizerroleflag, o.relauthorizerroleflag) as relauthorizerroleflag -- 
    ,nvl(n.wthrguart, o.wthrguart) as wthrguart -- 
    ,nvl(n.isrelatemaxentholder, o.isrelatemaxentholder) as isrelatemaxentholder -- 
    ,nvl(n.relationship, o.relationship) as relationship -- 
    ,nvl(n.relcorpname, o.relcorpname) as relcorpname -- 
    ,nvl(n.relcorpprop, o.relcorpprop) as relcorpprop -- 
    ,nvl(n.relemplmyears, o.relemplmyears) as relemplmyears -- 
    ,nvl(n.relcorpadr, o.relcorpadr) as relcorpadr -- 
    ,nvl(n.relcorptel, o.relcorptel) as relcorptel -- 
    ,nvl(n.reltaxaftermonincome, o.reltaxaftermonincome) as reltaxaftermonincome -- 
    ,nvl(n.relethnic, o.relethnic) as relethnic -- 
    ,nvl(n.relresiadr, o.relresiadr) as relresiadr -- 
    ,nvl(n.relwthrhouse, o.relwthrhouse) as relwthrhouse -- 
    ,nvl(n.relsocscrcontsmont, o.relsocscrcontsmont) as relsocscrcontsmont -- 
    ,nvl(n.relfundcontsmont, o.relfundcontsmont) as relfundcontsmont -- 
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
from (select * from ${iol_schema}.icms_fkd_rel_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_rel_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativeserialno <> n.relativeserialno
        or o.reltyp <> n.reltyp
        or o.relname <> n.relname
        or o.reltelno <> n.reltelno
        or o.relidtype <> n.relidtype
        or o.relidno <> n.relidno
        or o.relrelationship <> n.relrelationship
        or o.relfamilycityid <> n.relfamilycityid
        or o.relfamilyaddr <> n.relfamilyaddr
        or o.relmarriage <> n.relmarriage
        or o.relpartnername <> n.relpartnername
        or o.relpartnertelno <> n.relpartnertelno
        or o.relpartneridtype <> n.relpartneridtype
        or o.relpartneridno <> n.relpartneridno
        or o.cusid <> n.cusid
        or o.fqzresult <> n.fqzresult
        or o.zxresult <> n.zxresult
        or o.remark <> n.remark
        or o.updatedate <> n.updatedate
        or o.naturecategoryrel <> n.naturecategoryrel
        or o.eduexperiencerel <> n.eduexperiencerel
        or o.ownshare <> n.ownshare
        or o.agriflg <> n.agriflg
        or o.businessesflag <> n.businessesflag
        or o.oblityp <> n.oblityp
        or o.pledgepkno <> n.pledgepkno
        or o.conshr <> n.conshr
        or o.immovables <> n.immovables
        or o.naturecategoryrelsps <> n.naturecategoryrelsps
        or o.relidexpire <> n.relidexpire
        or o.migtflag <> n.migtflag
        or o.relnation <> n.relnation
        or o.relcareer <> n.relcareer
        or o.relsex <> n.relsex
        or o.relcareercomm <> n.relcareercomm
        or o.relpartneridexpire <> n.relpartneridexpire
        or o.relpartnernation <> n.relpartnernation
        or o.relpartnercareer <> n.relpartnercareer
        or o.relpartnersex <> n.relpartnersex
        or o.relpartneraddr <> n.relpartneraddr
        or o.relpartnercareercomm <> n.relpartnercareercomm
        or o.relideffective <> n.relideffective
        or o.taxqueryflag <> n.taxqueryflag
        or o.taxauthorizeno <> n.taxauthorizeno
        or o.taxpayeridentityno <> n.taxpayeridentityno
        or o.coboinvtstkperc <> n.coboinvtstkperc
        or o.relannualincome <> n.relannualincome
        or o.relauthorizerroleflag <> n.relauthorizerroleflag
        or o.wthrguart <> n.wthrguart
        or o.isrelatemaxentholder <> n.isrelatemaxentholder
        or o.relationship <> n.relationship
        or o.relcorpname <> n.relcorpname
        or o.relcorpprop <> n.relcorpprop
        or o.relemplmyears <> n.relemplmyears
        or o.relcorpadr <> n.relcorpadr
        or o.relcorptel <> n.relcorptel
        or o.reltaxaftermonincome <> n.reltaxaftermonincome
        or o.relethnic <> n.relethnic
        or o.relresiadr <> n.relresiadr
        or o.relwthrhouse <> n.relwthrhouse
        or o.relsocscrcontsmont <> n.relsocscrcontsmont
        or o.relfundcontsmont <> n.relfundcontsmont
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_rel_list_cl(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,reltyp -- 关联人类型
            ,relname -- 关联人姓名
            ,reltelno -- 关联人手机号码
            ,relidtype -- 关联人证件类型
            ,relidno -- 关联人证件号码
            ,relrelationship -- 与主借款人关系
            ,relfamilycityid -- 关联人居住地址城市编号
            ,relfamilyaddr -- 关联人居住地址
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,relpartnertelno -- 关联人配偶手机号码
            ,relpartneridtype -- 关联人配偶证件类型
            ,relpartneridno -- 关联人配偶证件号码
            ,cusid -- 客户号
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,remark -- 备注
            ,updatedate -- 更新时间
            ,naturecategoryrel -- 关联人户籍性质
            ,eduexperiencerel -- 关联人学历
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,oblityp -- 智贷去权利人类型
            ,pledgepkno -- 智贷质押物信息主键
            ,conshr -- 智贷权利人共有份额
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,relidexpire -- 关联人证件到期日
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,relnation -- 关联人国籍
            ,relcareer -- 关联人职业
            ,relsex -- 关联人性别
            ,relcareercomm -- 关联人职业备注信息
            ,relpartneridexpire -- 关联人配偶证件失效日期
            ,relpartnernation -- 关联人配偶国籍
            ,relpartnercareer -- 关联人配偶职业
            ,relpartnersex -- 关联人配偶性别
            ,relpartneraddr -- 关联人配偶居住地址
            ,relpartnercareercomm -- 关联人配偶职业备注信息
            ,relideffective -- 
            ,taxqueryflag -- 
            ,taxauthorizeno -- 
            ,taxpayeridentityno -- 
            ,coboinvtstkperc -- 
            ,relannualincome -- 
            ,relauthorizerroleflag -- 
            ,wthrguart -- 
            ,isrelatemaxentholder -- 
            ,relationship -- 
            ,relcorpname -- 
            ,relcorpprop -- 
            ,relemplmyears -- 
            ,relcorpadr -- 
            ,relcorptel -- 
            ,reltaxaftermonincome -- 
            ,relethnic -- 
            ,relresiadr -- 
            ,relwthrhouse -- 
            ,relsocscrcontsmont -- 
            ,relfundcontsmont -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_rel_list_op(
            serialno -- 主键
            ,relativeserialno -- 业务流水号
            ,reltyp -- 关联人类型
            ,relname -- 关联人姓名
            ,reltelno -- 关联人手机号码
            ,relidtype -- 关联人证件类型
            ,relidno -- 关联人证件号码
            ,relrelationship -- 与主借款人关系
            ,relfamilycityid -- 关联人居住地址城市编号
            ,relfamilyaddr -- 关联人居住地址
            ,relmarriage -- 关联人婚姻状况
            ,relpartnername -- 关联人配偶姓名
            ,relpartnertelno -- 关联人配偶手机号码
            ,relpartneridtype -- 关联人配偶证件类型
            ,relpartneridno -- 关联人配偶证件号码
            ,cusid -- 客户号
            ,fqzresult -- 反欺诈结果
            ,zxresult -- 征信结果
            ,remark -- 备注
            ,updatedate -- 更新时间
            ,naturecategoryrel -- 关联人户籍性质
            ,eduexperiencerel -- 关联人学历
            ,ownshare -- 抵押人对抵押物拥有的份额
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,oblityp -- 智贷去权利人类型
            ,pledgepkno -- 智贷质押物信息主键
            ,conshr -- 智贷权利人共有份额
            ,immovables -- 不动产共有情况
            ,naturecategoryrelsps -- 关联人配偶户籍性质
            ,relidexpire -- 关联人证件到期日
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,relnation -- 关联人国籍
            ,relcareer -- 关联人职业
            ,relsex -- 关联人性别
            ,relcareercomm -- 关联人职业备注信息
            ,relpartneridexpire -- 关联人配偶证件失效日期
            ,relpartnernation -- 关联人配偶国籍
            ,relpartnercareer -- 关联人配偶职业
            ,relpartnersex -- 关联人配偶性别
            ,relpartneraddr -- 关联人配偶居住地址
            ,relpartnercareercomm -- 关联人配偶职业备注信息
            ,relideffective -- 
            ,taxqueryflag -- 
            ,taxauthorizeno -- 
            ,taxpayeridentityno -- 
            ,coboinvtstkperc -- 
            ,relannualincome -- 
            ,relauthorizerroleflag -- 
            ,wthrguart -- 
            ,isrelatemaxentholder -- 
            ,relationship -- 
            ,relcorpname -- 
            ,relcorpprop -- 
            ,relemplmyears -- 
            ,relcorpadr -- 
            ,relcorptel -- 
            ,reltaxaftermonincome -- 
            ,relethnic -- 
            ,relresiadr -- 
            ,relwthrhouse -- 
            ,relsocscrcontsmont -- 
            ,relfundcontsmont -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.relativeserialno -- 业务流水号
    ,o.reltyp -- 关联人类型
    ,o.relname -- 关联人姓名
    ,o.reltelno -- 关联人手机号码
    ,o.relidtype -- 关联人证件类型
    ,o.relidno -- 关联人证件号码
    ,o.relrelationship -- 与主借款人关系
    ,o.relfamilycityid -- 关联人居住地址城市编号
    ,o.relfamilyaddr -- 关联人居住地址
    ,o.relmarriage -- 关联人婚姻状况
    ,o.relpartnername -- 关联人配偶姓名
    ,o.relpartnertelno -- 关联人配偶手机号码
    ,o.relpartneridtype -- 关联人配偶证件类型
    ,o.relpartneridno -- 关联人配偶证件号码
    ,o.cusid -- 客户号
    ,o.fqzresult -- 反欺诈结果
    ,o.zxresult -- 征信结果
    ,o.remark -- 备注
    ,o.updatedate -- 更新时间
    ,o.naturecategoryrel -- 关联人户籍性质
    ,o.eduexperiencerel -- 关联人学历
    ,o.ownshare -- 抵押人对抵押物拥有的份额
    ,o.agriflg -- 是否农户
    ,o.businessesflag -- 客户性质
    ,o.oblityp -- 智贷去权利人类型
    ,o.pledgepkno -- 智贷质押物信息主键
    ,o.conshr -- 智贷权利人共有份额
    ,o.immovables -- 不动产共有情况
    ,o.naturecategoryrelsps -- 关联人配偶户籍性质
    ,o.relidexpire -- 关联人证件到期日
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.relnation -- 关联人国籍
    ,o.relcareer -- 关联人职业
    ,o.relsex -- 关联人性别
    ,o.relcareercomm -- 关联人职业备注信息
    ,o.relpartneridexpire -- 关联人配偶证件失效日期
    ,o.relpartnernation -- 关联人配偶国籍
    ,o.relpartnercareer -- 关联人配偶职业
    ,o.relpartnersex -- 关联人配偶性别
    ,o.relpartneraddr -- 关联人配偶居住地址
    ,o.relpartnercareercomm -- 关联人配偶职业备注信息
    ,o.relideffective -- 
    ,o.taxqueryflag -- 
    ,o.taxauthorizeno -- 
    ,o.taxpayeridentityno -- 
    ,o.coboinvtstkperc -- 
    ,o.relannualincome -- 
    ,o.relauthorizerroleflag -- 
    ,o.wthrguart -- 
    ,o.isrelatemaxentholder -- 
    ,o.relationship -- 
    ,o.relcorpname -- 
    ,o.relcorpprop -- 
    ,o.relemplmyears -- 
    ,o.relcorpadr -- 
    ,o.relcorptel -- 
    ,o.reltaxaftermonincome -- 
    ,o.relethnic -- 
    ,o.relresiadr -- 
    ,o.relwthrhouse -- 
    ,o.relsocscrcontsmont -- 
    ,o.relfundcontsmont -- 
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
from ${iol_schema}.icms_fkd_rel_list_bk o
    left join ${iol_schema}.icms_fkd_rel_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_rel_list_cl d
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
--truncate table ${iol_schema}.icms_fkd_rel_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_rel_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_rel_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_rel_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_rel_list exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_rel_list_cl;
alter table ${iol_schema}.icms_fkd_rel_list exchange partition p_20991231 with table ${iol_schema}.icms_fkd_rel_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_rel_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_rel_list_op purge;
drop table ${iol_schema}.icms_fkd_rel_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_rel_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_rel_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
