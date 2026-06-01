/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_house_list
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
create table ${iol_schema}.icms_fkd_house_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_house_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_house_list_op purge;
drop table ${iol_schema}.icms_fkd_house_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_house_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_house_list where 0=1;

create table ${iol_schema}.icms_fkd_house_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_house_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_house_list_cl(
            serialno -- 主键
            ,areaname -- 区域名称
            ,buildingcode -- 楼号
            ,cusnamehire -- 承租人
            ,startdatehire -- 租赁起始日期
            ,obligee -- 上手权利人
            ,spareroomisclearinghouse -- 备用房是否清房
            ,titlecertificategettime -- 土地使用权起始日期
            ,cityareacode -- 城市编码
            ,spareroomcount -- 备用房数量
            ,obligeeind -- 主借人权利人标志
            ,housetype -- 房屋结构类型
            ,certcodehire -- 承租人证件号码
            ,assessmenttype -- 评估方式
            ,formalprice -- 正式评估价值
            ,hsobligeerelative -- 产权共有人关系
            ,hsovergroundarea -- 地上面积
            ,housestatus -- 房屋状态
            ,projectname -- 楼盘地址（小区名称）
            ,islease -- 是否出租
            ,gettime -- 产权证书取得时间
            ,mortgageamt -- 上手抵押金额
            ,roomsize -- 房屋面积
            ,leasetime -- 出租时间
            ,hsisbasement -- 有无地下室
            ,housepurpose -- 房屋用途
            ,remark -- 备注
            ,enddatehire -- 租赁终止日期
            ,coownership -- 共有情况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,hsbasementarea -- 地下面积
            ,bkprice -- 贝壳网房产评估价值
            ,cityname -- 城市名称
            ,lineprice -- 线上评估价值
            ,hsupperinmortgagedate -- 入抵日期
            ,hsupperoutmortgagedate -- 解抵日期
            ,certtypehire -- 承租人证件类型
            ,relativeserialno -- 业务流水号
            ,areacode -- 区域编码
            ,projectid -- 楼盘编号
            ,isvacant -- 是否空置
            ,getmode -- 取得方式
            ,propertyrightduedate -- 土地使用权到期日期
            ,hsdecoratestate -- 房产装修情况
            ,pledgeind -- 是否本次抵押
            ,hscoveredarea -- 建筑面积
            ,mourent -- 月租金
            ,frontcode -- 朝向
            ,rentcycle -- 租金收缴周期
            ,propertytype -- 房产类型
            ,floorno -- 楼层
            ,roomno -- 单元室
            ,buildingdate -- 建成年份
            ,isclearinghouse -- 是否清房
            ,landcategory -- 土地性质
            ,spareroomaddr -- 备用房地址
            ,gurtrate -- 担保率
            ,projectaddr -- 楼盘位置
            ,assessmentcom -- 评估公司名称
            ,partnerobligeeind -- 配偶权利人标志
            ,totalfloor -- 总楼层
            ,isevlbld -- 是否电梯楼
            ,contmode -- 房产所属人联系方式
            ,custname -- 房产所属人姓名
            ,propertydueyear -- 土地使用年限
            ,valuationkh -- 客户录入评估总价
            ,iscompleted -- 
            ,yearlyrental -- 
            ,houseid -- 
            ,valuationdzy -- 
            ,address -- 
            ,reltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_house_list_op(
            serialno -- 主键
            ,areaname -- 区域名称
            ,buildingcode -- 楼号
            ,cusnamehire -- 承租人
            ,startdatehire -- 租赁起始日期
            ,obligee -- 上手权利人
            ,spareroomisclearinghouse -- 备用房是否清房
            ,titlecertificategettime -- 土地使用权起始日期
            ,cityareacode -- 城市编码
            ,spareroomcount -- 备用房数量
            ,obligeeind -- 主借人权利人标志
            ,housetype -- 房屋结构类型
            ,certcodehire -- 承租人证件号码
            ,assessmenttype -- 评估方式
            ,formalprice -- 正式评估价值
            ,hsobligeerelative -- 产权共有人关系
            ,hsovergroundarea -- 地上面积
            ,housestatus -- 房屋状态
            ,projectname -- 楼盘地址（小区名称）
            ,islease -- 是否出租
            ,gettime -- 产权证书取得时间
            ,mortgageamt -- 上手抵押金额
            ,roomsize -- 房屋面积
            ,leasetime -- 出租时间
            ,hsisbasement -- 有无地下室
            ,housepurpose -- 房屋用途
            ,remark -- 备注
            ,enddatehire -- 租赁终止日期
            ,coownership -- 共有情况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,hsbasementarea -- 地下面积
            ,bkprice -- 贝壳网房产评估价值
            ,cityname -- 城市名称
            ,lineprice -- 线上评估价值
            ,hsupperinmortgagedate -- 入抵日期
            ,hsupperoutmortgagedate -- 解抵日期
            ,certtypehire -- 承租人证件类型
            ,relativeserialno -- 业务流水号
            ,areacode -- 区域编码
            ,projectid -- 楼盘编号
            ,isvacant -- 是否空置
            ,getmode -- 取得方式
            ,propertyrightduedate -- 土地使用权到期日期
            ,hsdecoratestate -- 房产装修情况
            ,pledgeind -- 是否本次抵押
            ,hscoveredarea -- 建筑面积
            ,mourent -- 月租金
            ,frontcode -- 朝向
            ,rentcycle -- 租金收缴周期
            ,propertytype -- 房产类型
            ,floorno -- 楼层
            ,roomno -- 单元室
            ,buildingdate -- 建成年份
            ,isclearinghouse -- 是否清房
            ,landcategory -- 土地性质
            ,spareroomaddr -- 备用房地址
            ,gurtrate -- 担保率
            ,projectaddr -- 楼盘位置
            ,assessmentcom -- 评估公司名称
            ,partnerobligeeind -- 配偶权利人标志
            ,totalfloor -- 总楼层
            ,isevlbld -- 是否电梯楼
            ,contmode -- 房产所属人联系方式
            ,custname -- 房产所属人姓名
            ,propertydueyear -- 土地使用年限
            ,valuationkh -- 客户录入评估总价
            ,iscompleted -- 
            ,yearlyrental -- 
            ,houseid -- 
            ,valuationdzy -- 
            ,address -- 
            ,reltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键
    ,nvl(n.areaname, o.areaname) as areaname -- 区域名称
    ,nvl(n.buildingcode, o.buildingcode) as buildingcode -- 楼号
    ,nvl(n.cusnamehire, o.cusnamehire) as cusnamehire -- 承租人
    ,nvl(n.startdatehire, o.startdatehire) as startdatehire -- 租赁起始日期
    ,nvl(n.obligee, o.obligee) as obligee -- 上手权利人
    ,nvl(n.spareroomisclearinghouse, o.spareroomisclearinghouse) as spareroomisclearinghouse -- 备用房是否清房
    ,nvl(n.titlecertificategettime, o.titlecertificategettime) as titlecertificategettime -- 土地使用权起始日期
    ,nvl(n.cityareacode, o.cityareacode) as cityareacode -- 城市编码
    ,nvl(n.spareroomcount, o.spareroomcount) as spareroomcount -- 备用房数量
    ,nvl(n.obligeeind, o.obligeeind) as obligeeind -- 主借人权利人标志
    ,nvl(n.housetype, o.housetype) as housetype -- 房屋结构类型
    ,nvl(n.certcodehire, o.certcodehire) as certcodehire -- 承租人证件号码
    ,nvl(n.assessmenttype, o.assessmenttype) as assessmenttype -- 评估方式
    ,nvl(n.formalprice, o.formalprice) as formalprice -- 正式评估价值
    ,nvl(n.hsobligeerelative, o.hsobligeerelative) as hsobligeerelative -- 产权共有人关系
    ,nvl(n.hsovergroundarea, o.hsovergroundarea) as hsovergroundarea -- 地上面积
    ,nvl(n.housestatus, o.housestatus) as housestatus -- 房屋状态
    ,nvl(n.projectname, o.projectname) as projectname -- 楼盘地址（小区名称）
    ,nvl(n.islease, o.islease) as islease -- 是否出租
    ,nvl(n.gettime, o.gettime) as gettime -- 产权证书取得时间
    ,nvl(n.mortgageamt, o.mortgageamt) as mortgageamt -- 上手抵押金额
    ,nvl(n.roomsize, o.roomsize) as roomsize -- 房屋面积
    ,nvl(n.leasetime, o.leasetime) as leasetime -- 出租时间
    ,nvl(n.hsisbasement, o.hsisbasement) as hsisbasement -- 有无地下室
    ,nvl(n.housepurpose, o.housepurpose) as housepurpose -- 房屋用途
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.enddatehire, o.enddatehire) as enddatehire -- 租赁终止日期
    ,nvl(n.coownership, o.coownership) as coownership -- 共有情况
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.hsbasementarea, o.hsbasementarea) as hsbasementarea -- 地下面积
    ,nvl(n.bkprice, o.bkprice) as bkprice -- 贝壳网房产评估价值
    ,nvl(n.cityname, o.cityname) as cityname -- 城市名称
    ,nvl(n.lineprice, o.lineprice) as lineprice -- 线上评估价值
    ,nvl(n.hsupperinmortgagedate, o.hsupperinmortgagedate) as hsupperinmortgagedate -- 入抵日期
    ,nvl(n.hsupperoutmortgagedate, o.hsupperoutmortgagedate) as hsupperoutmortgagedate -- 解抵日期
    ,nvl(n.certtypehire, o.certtypehire) as certtypehire -- 承租人证件类型
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 业务流水号
    ,nvl(n.areacode, o.areacode) as areacode -- 区域编码
    ,nvl(n.projectid, o.projectid) as projectid -- 楼盘编号
    ,nvl(n.isvacant, o.isvacant) as isvacant -- 是否空置
    ,nvl(n.getmode, o.getmode) as getmode -- 取得方式
    ,nvl(n.propertyrightduedate, o.propertyrightduedate) as propertyrightduedate -- 土地使用权到期日期
    ,nvl(n.hsdecoratestate, o.hsdecoratestate) as hsdecoratestate -- 房产装修情况
    ,nvl(n.pledgeind, o.pledgeind) as pledgeind -- 是否本次抵押
    ,nvl(n.hscoveredarea, o.hscoveredarea) as hscoveredarea -- 建筑面积
    ,nvl(n.mourent, o.mourent) as mourent -- 月租金
    ,nvl(n.frontcode, o.frontcode) as frontcode -- 朝向
    ,nvl(n.rentcycle, o.rentcycle) as rentcycle -- 租金收缴周期
    ,nvl(n.propertytype, o.propertytype) as propertytype -- 房产类型
    ,nvl(n.floorno, o.floorno) as floorno -- 楼层
    ,nvl(n.roomno, o.roomno) as roomno -- 单元室
    ,nvl(n.buildingdate, o.buildingdate) as buildingdate -- 建成年份
    ,nvl(n.isclearinghouse, o.isclearinghouse) as isclearinghouse -- 是否清房
    ,nvl(n.landcategory, o.landcategory) as landcategory -- 土地性质
    ,nvl(n.spareroomaddr, o.spareroomaddr) as spareroomaddr -- 备用房地址
    ,nvl(n.gurtrate, o.gurtrate) as gurtrate -- 担保率
    ,nvl(n.projectaddr, o.projectaddr) as projectaddr -- 楼盘位置
    ,nvl(n.assessmentcom, o.assessmentcom) as assessmentcom -- 评估公司名称
    ,nvl(n.partnerobligeeind, o.partnerobligeeind) as partnerobligeeind -- 配偶权利人标志
    ,nvl(n.totalfloor, o.totalfloor) as totalfloor -- 总楼层
    ,nvl(n.isevlbld, o.isevlbld) as isevlbld -- 是否电梯楼
    ,nvl(n.contmode, o.contmode) as contmode -- 房产所属人联系方式
    ,nvl(n.custname, o.custname) as custname -- 房产所属人姓名
    ,nvl(n.propertydueyear, o.propertydueyear) as propertydueyear -- 土地使用年限
    ,nvl(n.valuationkh, o.valuationkh) as valuationkh -- 客户录入评估总价
    ,nvl(n.iscompleted, o.iscompleted) as iscompleted -- 
    ,nvl(n.yearlyrental, o.yearlyrental) as yearlyrental -- 
    ,nvl(n.houseid, o.houseid) as houseid -- 
    ,nvl(n.valuationdzy, o.valuationdzy) as valuationdzy -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.reltype, o.reltype) as reltype -- 
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
from (select * from ${iol_schema}.icms_fkd_house_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_house_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.areaname <> n.areaname
        or o.buildingcode <> n.buildingcode
        or o.cusnamehire <> n.cusnamehire
        or o.startdatehire <> n.startdatehire
        or o.obligee <> n.obligee
        or o.spareroomisclearinghouse <> n.spareroomisclearinghouse
        or o.titlecertificategettime <> n.titlecertificategettime
        or o.cityareacode <> n.cityareacode
        or o.spareroomcount <> n.spareroomcount
        or o.obligeeind <> n.obligeeind
        or o.housetype <> n.housetype
        or o.certcodehire <> n.certcodehire
        or o.assessmenttype <> n.assessmenttype
        or o.formalprice <> n.formalprice
        or o.hsobligeerelative <> n.hsobligeerelative
        or o.hsovergroundarea <> n.hsovergroundarea
        or o.housestatus <> n.housestatus
        or o.projectname <> n.projectname
        or o.islease <> n.islease
        or o.gettime <> n.gettime
        or o.mortgageamt <> n.mortgageamt
        or o.roomsize <> n.roomsize
        or o.leasetime <> n.leasetime
        or o.hsisbasement <> n.hsisbasement
        or o.housepurpose <> n.housepurpose
        or o.remark <> n.remark
        or o.enddatehire <> n.enddatehire
        or o.coownership <> n.coownership
        or o.migtflag <> n.migtflag
        or o.hsbasementarea <> n.hsbasementarea
        or o.bkprice <> n.bkprice
        or o.cityname <> n.cityname
        or o.lineprice <> n.lineprice
        or o.hsupperinmortgagedate <> n.hsupperinmortgagedate
        or o.hsupperoutmortgagedate <> n.hsupperoutmortgagedate
        or o.certtypehire <> n.certtypehire
        or o.relativeserialno <> n.relativeserialno
        or o.areacode <> n.areacode
        or o.projectid <> n.projectid
        or o.isvacant <> n.isvacant
        or o.getmode <> n.getmode
        or o.propertyrightduedate <> n.propertyrightduedate
        or o.hsdecoratestate <> n.hsdecoratestate
        or o.pledgeind <> n.pledgeind
        or o.hscoveredarea <> n.hscoveredarea
        or o.mourent <> n.mourent
        or o.frontcode <> n.frontcode
        or o.rentcycle <> n.rentcycle
        or o.propertytype <> n.propertytype
        or o.floorno <> n.floorno
        or o.roomno <> n.roomno
        or o.buildingdate <> n.buildingdate
        or o.isclearinghouse <> n.isclearinghouse
        or o.landcategory <> n.landcategory
        or o.spareroomaddr <> n.spareroomaddr
        or o.gurtrate <> n.gurtrate
        or o.projectaddr <> n.projectaddr
        or o.assessmentcom <> n.assessmentcom
        or o.partnerobligeeind <> n.partnerobligeeind
        or o.totalfloor <> n.totalfloor
        or o.isevlbld <> n.isevlbld
        or o.contmode <> n.contmode
        or o.custname <> n.custname
        or o.propertydueyear <> n.propertydueyear
        or o.valuationkh <> n.valuationkh
        or o.iscompleted <> n.iscompleted
        or o.yearlyrental <> n.yearlyrental
        or o.houseid <> n.houseid
        or o.valuationdzy <> n.valuationdzy
        or o.address <> n.address
        or o.reltype <> n.reltype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_house_list_cl(
            serialno -- 主键
            ,areaname -- 区域名称
            ,buildingcode -- 楼号
            ,cusnamehire -- 承租人
            ,startdatehire -- 租赁起始日期
            ,obligee -- 上手权利人
            ,spareroomisclearinghouse -- 备用房是否清房
            ,titlecertificategettime -- 土地使用权起始日期
            ,cityareacode -- 城市编码
            ,spareroomcount -- 备用房数量
            ,obligeeind -- 主借人权利人标志
            ,housetype -- 房屋结构类型
            ,certcodehire -- 承租人证件号码
            ,assessmenttype -- 评估方式
            ,formalprice -- 正式评估价值
            ,hsobligeerelative -- 产权共有人关系
            ,hsovergroundarea -- 地上面积
            ,housestatus -- 房屋状态
            ,projectname -- 楼盘地址（小区名称）
            ,islease -- 是否出租
            ,gettime -- 产权证书取得时间
            ,mortgageamt -- 上手抵押金额
            ,roomsize -- 房屋面积
            ,leasetime -- 出租时间
            ,hsisbasement -- 有无地下室
            ,housepurpose -- 房屋用途
            ,remark -- 备注
            ,enddatehire -- 租赁终止日期
            ,coownership -- 共有情况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,hsbasementarea -- 地下面积
            ,bkprice -- 贝壳网房产评估价值
            ,cityname -- 城市名称
            ,lineprice -- 线上评估价值
            ,hsupperinmortgagedate -- 入抵日期
            ,hsupperoutmortgagedate -- 解抵日期
            ,certtypehire -- 承租人证件类型
            ,relativeserialno -- 业务流水号
            ,areacode -- 区域编码
            ,projectid -- 楼盘编号
            ,isvacant -- 是否空置
            ,getmode -- 取得方式
            ,propertyrightduedate -- 土地使用权到期日期
            ,hsdecoratestate -- 房产装修情况
            ,pledgeind -- 是否本次抵押
            ,hscoveredarea -- 建筑面积
            ,mourent -- 月租金
            ,frontcode -- 朝向
            ,rentcycle -- 租金收缴周期
            ,propertytype -- 房产类型
            ,floorno -- 楼层
            ,roomno -- 单元室
            ,buildingdate -- 建成年份
            ,isclearinghouse -- 是否清房
            ,landcategory -- 土地性质
            ,spareroomaddr -- 备用房地址
            ,gurtrate -- 担保率
            ,projectaddr -- 楼盘位置
            ,assessmentcom -- 评估公司名称
            ,partnerobligeeind -- 配偶权利人标志
            ,totalfloor -- 总楼层
            ,isevlbld -- 是否电梯楼
            ,contmode -- 房产所属人联系方式
            ,custname -- 房产所属人姓名
            ,propertydueyear -- 土地使用年限
            ,valuationkh -- 客户录入评估总价
            ,iscompleted -- 
            ,yearlyrental -- 
            ,houseid -- 
            ,valuationdzy -- 
            ,address -- 
            ,reltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_house_list_op(
            serialno -- 主键
            ,areaname -- 区域名称
            ,buildingcode -- 楼号
            ,cusnamehire -- 承租人
            ,startdatehire -- 租赁起始日期
            ,obligee -- 上手权利人
            ,spareroomisclearinghouse -- 备用房是否清房
            ,titlecertificategettime -- 土地使用权起始日期
            ,cityareacode -- 城市编码
            ,spareroomcount -- 备用房数量
            ,obligeeind -- 主借人权利人标志
            ,housetype -- 房屋结构类型
            ,certcodehire -- 承租人证件号码
            ,assessmenttype -- 评估方式
            ,formalprice -- 正式评估价值
            ,hsobligeerelative -- 产权共有人关系
            ,hsovergroundarea -- 地上面积
            ,housestatus -- 房屋状态
            ,projectname -- 楼盘地址（小区名称）
            ,islease -- 是否出租
            ,gettime -- 产权证书取得时间
            ,mortgageamt -- 上手抵押金额
            ,roomsize -- 房屋面积
            ,leasetime -- 出租时间
            ,hsisbasement -- 有无地下室
            ,housepurpose -- 房屋用途
            ,remark -- 备注
            ,enddatehire -- 租赁终止日期
            ,coownership -- 共有情况
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,hsbasementarea -- 地下面积
            ,bkprice -- 贝壳网房产评估价值
            ,cityname -- 城市名称
            ,lineprice -- 线上评估价值
            ,hsupperinmortgagedate -- 入抵日期
            ,hsupperoutmortgagedate -- 解抵日期
            ,certtypehire -- 承租人证件类型
            ,relativeserialno -- 业务流水号
            ,areacode -- 区域编码
            ,projectid -- 楼盘编号
            ,isvacant -- 是否空置
            ,getmode -- 取得方式
            ,propertyrightduedate -- 土地使用权到期日期
            ,hsdecoratestate -- 房产装修情况
            ,pledgeind -- 是否本次抵押
            ,hscoveredarea -- 建筑面积
            ,mourent -- 月租金
            ,frontcode -- 朝向
            ,rentcycle -- 租金收缴周期
            ,propertytype -- 房产类型
            ,floorno -- 楼层
            ,roomno -- 单元室
            ,buildingdate -- 建成年份
            ,isclearinghouse -- 是否清房
            ,landcategory -- 土地性质
            ,spareroomaddr -- 备用房地址
            ,gurtrate -- 担保率
            ,projectaddr -- 楼盘位置
            ,assessmentcom -- 评估公司名称
            ,partnerobligeeind -- 配偶权利人标志
            ,totalfloor -- 总楼层
            ,isevlbld -- 是否电梯楼
            ,contmode -- 房产所属人联系方式
            ,custname -- 房产所属人姓名
            ,propertydueyear -- 土地使用年限
            ,valuationkh -- 客户录入评估总价
            ,iscompleted -- 
            ,yearlyrental -- 
            ,houseid -- 
            ,valuationdzy -- 
            ,address -- 
            ,reltype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键
    ,o.areaname -- 区域名称
    ,o.buildingcode -- 楼号
    ,o.cusnamehire -- 承租人
    ,o.startdatehire -- 租赁起始日期
    ,o.obligee -- 上手权利人
    ,o.spareroomisclearinghouse -- 备用房是否清房
    ,o.titlecertificategettime -- 土地使用权起始日期
    ,o.cityareacode -- 城市编码
    ,o.spareroomcount -- 备用房数量
    ,o.obligeeind -- 主借人权利人标志
    ,o.housetype -- 房屋结构类型
    ,o.certcodehire -- 承租人证件号码
    ,o.assessmenttype -- 评估方式
    ,o.formalprice -- 正式评估价值
    ,o.hsobligeerelative -- 产权共有人关系
    ,o.hsovergroundarea -- 地上面积
    ,o.housestatus -- 房屋状态
    ,o.projectname -- 楼盘地址（小区名称）
    ,o.islease -- 是否出租
    ,o.gettime -- 产权证书取得时间
    ,o.mortgageamt -- 上手抵押金额
    ,o.roomsize -- 房屋面积
    ,o.leasetime -- 出租时间
    ,o.hsisbasement -- 有无地下室
    ,o.housepurpose -- 房屋用途
    ,o.remark -- 备注
    ,o.enddatehire -- 租赁终止日期
    ,o.coownership -- 共有情况
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.hsbasementarea -- 地下面积
    ,o.bkprice -- 贝壳网房产评估价值
    ,o.cityname -- 城市名称
    ,o.lineprice -- 线上评估价值
    ,o.hsupperinmortgagedate -- 入抵日期
    ,o.hsupperoutmortgagedate -- 解抵日期
    ,o.certtypehire -- 承租人证件类型
    ,o.relativeserialno -- 业务流水号
    ,o.areacode -- 区域编码
    ,o.projectid -- 楼盘编号
    ,o.isvacant -- 是否空置
    ,o.getmode -- 取得方式
    ,o.propertyrightduedate -- 土地使用权到期日期
    ,o.hsdecoratestate -- 房产装修情况
    ,o.pledgeind -- 是否本次抵押
    ,o.hscoveredarea -- 建筑面积
    ,o.mourent -- 月租金
    ,o.frontcode -- 朝向
    ,o.rentcycle -- 租金收缴周期
    ,o.propertytype -- 房产类型
    ,o.floorno -- 楼层
    ,o.roomno -- 单元室
    ,o.buildingdate -- 建成年份
    ,o.isclearinghouse -- 是否清房
    ,o.landcategory -- 土地性质
    ,o.spareroomaddr -- 备用房地址
    ,o.gurtrate -- 担保率
    ,o.projectaddr -- 楼盘位置
    ,o.assessmentcom -- 评估公司名称
    ,o.partnerobligeeind -- 配偶权利人标志
    ,o.totalfloor -- 总楼层
    ,o.isevlbld -- 是否电梯楼
    ,o.contmode -- 房产所属人联系方式
    ,o.custname -- 房产所属人姓名
    ,o.propertydueyear -- 土地使用年限
    ,o.valuationkh -- 客户录入评估总价
    ,o.iscompleted -- 
    ,o.yearlyrental -- 
    ,o.houseid -- 
    ,o.valuationdzy -- 
    ,o.address -- 
    ,o.reltype -- 
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
from ${iol_schema}.icms_fkd_house_list_bk o
    left join ${iol_schema}.icms_fkd_house_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_house_list_cl d
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
--truncate table ${iol_schema}.icms_fkd_house_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_house_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_house_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_house_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_house_list exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_house_list_cl;
alter table ${iol_schema}.icms_fkd_house_list exchange partition p_20991231 with table ${iol_schema}.icms_fkd_house_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_house_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_house_list_op purge;
drop table ${iol_schema}.icms_fkd_house_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_house_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_house_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
